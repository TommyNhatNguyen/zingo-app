import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/core/blocs/practice-sessions/complete-practice/complete_practice_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/complete-practice/complete_practice_event.dart';
import 'package:zingo/core/blocs/practice-sessions/complete-practice/complete_practice_state.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_state.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/dtos/practice-sessions/complete_session_payload.dart';
import 'package:zingo/domain/models/dialog.dart' as dialog_model;
import 'package:zingo/domain/models/dialog_turn.dart';
import 'package:zingo/utils/cache_service.dart';
import 'package:zingo/utils/matching_text_service.dart';
import 'package:zingo/utils/speech_to_text_service.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/utils/debounce_util.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_bloc.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_state.dart';
import 'package:zingo/ui/practice/widgets/ai_message.dart';
import 'package:zingo/ui/practice/widgets/practice_control_bar.dart';
import 'package:zingo/ui/practice/widgets/user_message.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    this.practiceSessionId = '1c11f53a-d653-4e1d-97e2-242e82ebe22b',
    this.dialogId = '13febbdf-a74c-4904-bc3b-c22bdec6a327',
    this.practiceMode = PracticeMode.readAloud,
    this.dialog,
  });

  final String practiceSessionId;
  final String dialogId;
  final PracticeMode practiceMode;
  final dialog_model.Dialog? dialog;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  static const double _retryThreshold = 0.4;
  static const _successTurnSound = 'assets/success-turn.aac';
  static const _errorTurnSound = 'assets/error-turn.aac';

  late final InMemoryChatController _chatController;
  late final PracticeScreenBloc _practiceScreenBloc;
  late final AuthBloc _authBloc;
  late final AudioPlayer _audioPlayer;
  late final AudioPlayer _sfxPlayer;
  bool _isLoadingDialogTurns = true;

  SpeechToText get _speechToTextController => SpeechToTextService.instance;
  final DebounceUtil _debouncer = DebounceUtil(milliseconds: 200);

  final Map<String, SentenceMatcher> _matchers = {};
  final Map<String, MatchResult> _finalMatchResults = {};
  final ValueNotifier<MatchResult?> _activeMatchResult = ValueNotifier(null);
  String? _activeTurnId;
  bool _isMicTransitioning = false;
  ToastificationItem? _micTransitioningToast;

  String? get _currentPlayingTurnId =>
      _practiceScreenBloc.state.playingDialogTurnID;
  int get _currentTurnIndex => _practiceScreenBloc.state.currentTurnIndex;
  int get totalTurns => _practiceScreenBloc.state.turns?.length ?? 0;
  bool get _hasActiveMatcher =>
      _activeTurnId != null && _matchers.containsKey(_activeTurnId);

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController();
    _practiceScreenBloc = context.read<PracticeScreenBloc>();
    _authBloc = context.read<AuthBloc>();
    _audioPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    _practiceScreenBloc.add(const PracticeScreenInitializeEvent());
  }

  @override
  void dispose() {
    _chatController.dispose();
    unawaited(_sfxPlayer.stop());
    _audioPlayer.dispose();
    _sfxPlayer.dispose();
    _activeMatchResult.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Turn sequencing
  // ---------------------------------------------------------------------------

  Future<void> _insertDialogTurn({
    required DialogTurn turn,
    required int currentTurnIndex,
  }) async {
    await _chatController.insertMessage(
      TextMessage(
        id: turn.id,
        authorId: turn.speaker.value,
        text: turn.line_text,
        metadata: turn.toJson(),
      ),
      index: currentTurnIndex,
    );
    _practiceScreenBloc.add(
      PracticeScreenInsertDialogTurnEvent(currentTurnIndex: currentTurnIndex),
    );

    if (turn.speaker == Speaker.user) {
      _activeTurnId = turn.id;
      _matchers[turn.id] = SentenceMatcher(
        turn.line_text,
        passThreshold: _retryThreshold,
      );
      _activeMatchResult.value = _matchers[turn.id]?.update('');
      return;
    }

    // AI turn: play audio then chain the next turn.
    final turns = _practiceScreenBloc.state.turns;
    final nextTurnIndex = currentTurnIndex + 1;
    if (turns == null || nextTurnIndex >= totalTurns) return;
    await _playDialogTurnAudio(turn: turn);
    await _insertDialogTurn(
      turn: turns[nextTurnIndex],
      currentTurnIndex: nextTurnIndex,
    );
  }

  Future<void> _continueToNextDialogTurn() async {
    final turns = _practiceScreenBloc.state.turns;
    final nextTurnIndex = _practiceScreenBloc.state.currentTurnIndex + 1;
    if (turns == null || nextTurnIndex >= turns.length) return;
    _practiceScreenBloc.add(PracticeScreenSetPhaseEvent(PracticePhase.idle));
    await _insertDialogTurn(
      turn: turns[nextTurnIndex],
      currentTurnIndex: nextTurnIndex,
    );
  }

  // ---------------------------------------------------------------------------
  // Audio playback
  // ---------------------------------------------------------------------------

  Future<void> _playDialogTurnAudio({required DialogTurn turn}) async {
    if (!mounted) return;
    if (_currentPlayingTurnId == turn.id) return;
    if (turn.tts_model_audio_url == null) {
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text(context.l10n.errorGeneric),
        description: Text(context.l10n.errorNoAudio),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    _practiceScreenBloc.add(
      PracticeScreenSetPlayingAudioEvent(turnId: turn.id),
    );
    _practiceScreenBloc.add(
      PracticeScreenSetPhaseEvent(PracticePhase.disabled),
    );
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
    final file = await AudioCacheService.instance.getSingleFile(
      turn.tts_model_audio_url!,
    );
    await _playAudio(audioUrl: file.uri.toString());
    if (_currentPlayingTurnId == turn.id) {
      _practiceScreenBloc.add(const PracticeScreenSetPlayingAudioEvent());
      _practiceScreenBloc.add(PracticeScreenSetPhaseEvent(PracticePhase.idle));
    }
  }

  Future<void> _playAudio({required String audioUrl}) async {
    await _audioPlayer.setUrl(audioUrl);
    await _audioPlayer.play();
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
  }

  Future<void> _playTurnFeedback({required bool success}) async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setAsset(
        success ? _successTurnSound : _errorTurnSound,
      );
      unawaited(_sfxPlayer.play());
    } catch (_) {
      // Ignore missing or unsupported sfx assets.
    }
  }

  // ---------------------------------------------------------------------------
  // Speech-to-text
  // ---------------------------------------------------------------------------

  /// Single source of truth for phase transitions after a user speaking turn.
  /// Idempotent — safe to call from both [_onRecognizedText] (on finalResult,
  /// which fires early) and [_handleListening] ("done" status, safety net).
  void _processResult() {
    if (!mounted) return;
    final phase = _practiceScreenBloc.state.phase;
    if (phase == PracticePhase.awaitingContinue ||
        phase == PracticePhase.finished ||
        phase == PracticePhase.awaitingRetry) {
      return;
    }

    final matchResult = _activeMatchResult.value;

    if (matchResult == null) {
      unawaited(_playTurnFeedback(success: false));
      _practiceScreenBloc.add(
        PracticeScreenSetPhaseEvent(PracticePhase.awaitingRetry),
      );
      return;
    }

    if (!matchResult.passed) {
      unawaited(_playTurnFeedback(success: false));
      Toastification().show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: Text(context.l10n.keepTrying),
        description: Text(
          context.l10n.accuracyTooLow(
            (matchResult.completion * 100).round(),
          ),
        ),
        autoCloseDuration: const Duration(seconds: 4),
      );
      _matchers[_activeTurnId!]!.reset();
      _activeMatchResult.value = _matchers[_activeTurnId!]!.update('');
      _practiceScreenBloc.add(
        PracticeScreenSetPhaseEvent(PracticePhase.awaitingRetry),
      );
      return;
    }

    if (_activeTurnId != null) {
      _finalMatchResults[_activeTurnId!] = matchResult;
    }

    unawaited(_playTurnFeedback(success: true));

    final nextTurnIndex = _currentTurnIndex + 1;
    final isLastTurn = nextTurnIndex >= totalTurns;

    if (isLastTurn) {
      Toastification().show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: Text(context.l10n.dialogCompleted),
        description: Text(context.l10n.dialogCompletedDesc),
        autoCloseDuration: const Duration(seconds: 4),
      );
      _practiceScreenBloc.add(
        PracticeScreenSetPhaseEvent(PracticePhase.finished),
      );
    } else {
      Toastification().show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: Text(context.l10n.niceKeepGoing),
        description: Text(context.l10n.tapContinue),
        autoCloseDuration: const Duration(seconds: 3),
      );
      _practiceScreenBloc.add(
        PracticeScreenSetPhaseEvent(PracticePhase.awaitingContinue),
      );
    }
  }

  void _handleListening(String status) {
    if (status == 'listening') {
      _practiceScreenBloc.add(
        PracticeScreenSetPhaseEvent(PracticePhase.listening),
      );
    } else if (status == 'done') {
      _processResult(); // safety net — idempotent if finalResult already handled it
    }
  }

  Future<void> _startSpeaking() async {
    _speechToTextController.statusListener = (status) {
      if (!mounted) return;
      _handleListening(status);
    };
    await _speechToTextController.listen(
      onResult: _onRecognizedText,
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(minutes: 1),
        pauseFor: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _stopSpeaking() async {
    await _speechToTextController.stop();
  }

  void _dismissMicTransitioningToast() {
    if (_micTransitioningToast != null) {
      Toastification().dismiss(_micTransitioningToast!);
      _micTransitioningToast = null;
    }
  }

  void _debounceToggleSpeaking() {
    print("here");
    if (_isMicTransitioning) {
      _micTransitioningToast ??= Toastification().show(
        context: context,
        style: ToastificationStyle.flat,
        title: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
        description: Text(context.l10n.micTransitioning),
      );
      return;
    }
    final phase = _practiceScreenBloc.state.phase;
    final shouldStart =
        phase == PracticePhase.idle || phase == PracticePhase.awaitingRetry;
    if (shouldStart) {
      _debouncer.run(() {
        if (_isMicTransitioning) return;
        setState(() => _isMicTransitioning = true);
        _startSpeaking().whenComplete(() {
          if (mounted) {
            setState(() => _isMicTransitioning = false);
            _dismissMicTransitioningToast();
          }
        });
      });
    } else if (phase == PracticePhase.listening) {
      _debouncer.run(() {
        if (_isMicTransitioning) return;
        setState(() => _isMicTransitioning = true);
        _stopSpeaking().whenComplete(() {
          if (mounted) {
            setState(() => _isMicTransitioning = false);
            _dismissMicTransitioningToast();
          }
        });
      });
    }
  }

  void _onRecognizedText(SpeechRecognitionResult result) {
    if (!mounted) return;
    if (_hasActiveMatcher) {
      _activeMatchResult.value = _matchers[_activeTurnId]?.update(
        result.recognizedWords,
      );
    }
    if (result.finalResult) {
      // _processResult();
    }
  }

  void _onEndTurn() {
    final turns = _practiceScreenBloc.state.turns;
    if (turns == null) return;

    final turnOrderById = {for (final t in turns) t.id: t.turn_order};

    final answers = _finalMatchResults.entries.map((entry) {
      final matchedTokens = entry.value.tokens.where(
        (token) => token.state == WordState.matched,
      );
      final answerText = matchedTokens.map((token) => token.display).join(' ');
      return SessionAnswer(
        turn_order: turnOrderById[entry.key] ?? 0,
        answer_text: answerText,
        passed: entry.value.passed,
        pass_threshold: _retryThreshold,
      );
    }).toList();

    context.read<CompletePracticeBloc>().add(
      CompletePracticeSubmit(
        payload: CompleteSessionPayload(
          id: widget.practiceSessionId,
          answers: answers,
          current_turn_order: _currentTurnIndex + 1,
        ),
      ),
    );
  }

  Future<void> _onBack() async {
    await _audioPlayer.stop();
    await _sfxPlayer.stop();
    await _speechToTextController.stop();
    if (!mounted) return;
    context.go('/learn');
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CompletePracticeBloc, CompletePracticeState>(
          listenWhen: (prev, curr) => prev.requestStatus != curr.requestStatus,
          listener: (context, state) {
            if (state.requestStatus == RequestStatus.success) {
              context.go('/streak-congrats', extra: {'session': state.data});
            } else if (state.requestStatus == RequestStatus.error) {
              Toastification().show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.flat,
                title: Text(context.l10n.errorGeneric),
                description: Text(state.error ?? context.l10n.errorGeneric),
                autoCloseDuration: const Duration(seconds: 4),
              );
            }
          },
        ),
        BlocListener<DialogTurnsListByDialogBloc, DialogTurnsListByDialogState>(
          listenWhen: (prev, curr) =>
              prev.requestStatus != curr.requestStatus &&
              curr.requestStatus == RequestStatus.success,
          listener: (context, state) async {
            if (state.data == null || state.data!.isEmpty) return;
            _practiceScreenBloc.add(
              PracticeScreenLoadDialogTurnsEvent(turns: state.data!),
            );
            setState(() {
              _isLoadingDialogTurns = false;
            });
            await _insertDialogTurn(
              turn: state.data!.first,
              currentTurnIndex: 0,
            );
          },
        ),
        BlocListener<SpeechToTextBloc, SpeechToTextState>(
          listener: (context, state) {
            if (_practiceScreenBloc.state.playingDialogTurnID != null) {
              if (!state.isEnabled) {
                _practiceScreenBloc.add(
                  PracticeScreenSetPhaseEvent(PracticePhase.disabled),
                );
              } else {
                _practiceScreenBloc.add(
                  PracticeScreenSetPhaseEvent(PracticePhase.idle),
                );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<PracticeScreenBloc, PracticeScreenViewState>(
        builder: (context, state) {
          final turns = state.turns;
          final turnsLength = turns?.length ?? 0;
          final progress = turnsLength == 0
              ? 0.0
              : ((state.currentTurnIndex + 1) / turnsLength).clamp(0.0, 1.0);

          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              leading: IconButton(
                onPressed: _onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.dialog?.title ?? 'N/A',
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.turnsProgress(
                          state.currentTurnIndex + 1,
                          turnsLength,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    borderRadius: BorderRadius.circular(36),
                    backgroundColor: AppColors.divider,
                    color: AppColors.primary,
                    minHeight: 4,
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: _isLoadingDialogTurns
                      ? const Center(child: CircularProgressIndicator())
                      : Chat(
                          currentUserId: _authBloc.state.user?.uid ?? '',
                          resolveUser: (UserID id) async => User(
                            id: id,
                            name: _authBloc.state.user?.displayName ?? '',
                          ),
                          chatController: _chatController,
                          builders: Builders(
                            chatMessageBuilder:
                                (
                                  context,
                                  message,
                                  index,
                                  animation,
                                  child, {
                                  groupStatus,
                                  isRemoved,
                                  required isSentByMe,
                                }) {
                                  final turn = DialogTurn.fromJson(
                                    message.metadata ?? {},
                                  );
                                  final isPlaying =
                                      state.playingDialogTurnID == turn.id;

                                  if (turn.speaker == Speaker.ai) {
                                    return AiMessage(
                                      turn: turn,
                                      index: index,
                                      isPlaying: isPlaying,
                                      onPlay: () =>
                                          _playDialogTurnAudio(turn: turn),
                                    );
                                  }

                                  // Active user turn: rebuilds on every STT word.
                                  if (turn.id == _activeTurnId) {
                                    return ListenableBuilder(
                                      listenable: _activeMatchResult,
                                      builder: (context, _) => UserMessage(
                                        turn: turn,
                                        index: index,
                                        isPlaying: isPlaying,
                                        onPlay: () =>
                                            _playDialogTurnAudio(turn: turn),
                                        tokens:
                                            _activeMatchResult.value?.tokens,
                                      ),
                                    );
                                  }

                                  // Completed user turn: static, uses final match result.
                                  return UserMessage(
                                    turn: turn,
                                    index: index,
                                    isPlaying: isPlaying,
                                    onPlay: () =>
                                        _playDialogTurnAudio(turn: turn),
                                    tokens: _finalMatchResults[turn.id]?.tokens,
                                  );
                                },
                            composerBuilder: (context) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                ),
                PracticeControlBar(
                  phase: state.phase,
                  onToggleSpeaking: _debounceToggleSpeaking,
                  onContinue: () => _continueToNextDialogTurn(),
                  onEndTurn: _onEndTurn,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
