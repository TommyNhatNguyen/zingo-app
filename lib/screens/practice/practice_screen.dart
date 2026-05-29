import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;
import 'package:zingo/models/dialog_turn.dart';
import 'package:zingo/screens/learn/learn-detail/learn_detail_screen.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_bloc.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';
import 'package:zingo/screens/practice/widgets/ai_message.dart';
import 'package:zingo/screens/practice/widgets/practice_control_bar.dart';
import 'package:zingo/screens/practice/widgets/user_message.dart';
import 'package:zingo/services/cache_service.dart';
import 'package:zingo/services/matching_text_service.dart';
import 'package:zingo/services/speech_to_text_service.dart';
import 'package:zingo/utils/debounce_util.dart';

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
  late final InMemoryChatController _chatController;
  late final PracticeScreenBloc _practiceScreenBloc;
  late final AudioPlayer _audioPlayer;

  final ValueNotifier<String?> _recognizedText = ValueNotifier<String?>(null);
  SpeechToText get _speechToTextController => SpeechToTextService.instance;
  final DebounceUtil _debouncer = DebounceUtil(milliseconds: 200);

  final Map<String, SentenceMatcher> _matchers = {};
  final Map<String, MatchResult> _finalMatchResults = {};
  final ValueNotifier<MatchResult?> _activeMatchResult = ValueNotifier(null);
  String? _activeTurnId;

  bool get _hasActiveMatcher =>
      _activeTurnId != null && _matchers.containsKey(_activeTurnId);

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController();
    _practiceScreenBloc = context.read<PracticeScreenBloc>();
    _audioPlayer = AudioPlayer();
    _practiceScreenBloc.add(const PracticeScreenInitializeEvent());
  }

  @override
  void dispose() {
    _chatController.dispose();
    _audioPlayer.dispose();
    _recognizedText.dispose();
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
      _matchers[turn.id] = SentenceMatcher(turn.line_text, passThreshold: 0.4);
      _activeMatchResult.value = _matchers[turn.id]!.update('');
      return;
    }

    // AI turn: play audio then chain the next turn.
    final turns = _practiceScreenBloc.state.turns;
    final nextTurnIndex = currentTurnIndex + 1;
    if (turns == null || nextTurnIndex >= turns.length) return;
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
    _recognizedText.value = null;
    await _insertDialogTurn(
      turn: turns[nextTurnIndex],
      currentTurnIndex: nextTurnIndex,
    );
  }

  // ---------------------------------------------------------------------------
  // Audio playback
  // ---------------------------------------------------------------------------

  Future<void> _playAudio({required String audioUrl}) async {
    await _audioPlayer.setUrl(audioUrl);
    await _audioPlayer.play();
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
  }

  Future<void> _playDialogTurnAudio({required DialogTurn turn}) async {
    if (_practiceScreenBloc.state.playingDialogTurnID == turn.id) return;

    if (turn.tts_model_audio_url == null) {
      if (!mounted) return;
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text('Error'),
        description: const Text('This turn does not have an audio yet!'),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    _practiceScreenBloc.add(
      PracticeScreenSetPlayingAudioEvent(turnId: turn.id),
    );

    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
    final file = await AudioCacheService.instance.getSingleFile(
      turn.tts_model_audio_url!,
    );
    await _playAudio(audioUrl: file.uri.toString());

    if (!mounted) return;
    if (_practiceScreenBloc.state.playingDialogTurnID == turn.id) {
      _practiceScreenBloc.add(const PracticeScreenSetPlayingAudioEvent());
    }
  }

  // ---------------------------------------------------------------------------
  // Speech-to-text
  // ---------------------------------------------------------------------------

  Future<void> _startSpeaking() async {
    try {
      _speechToTextController.statusListener = (status) {
        if (!mounted) return;
        print("Status: $status");
        if (status == 'listening') {
          _practiceScreenBloc.add(
            PracticeScreenSetPhaseEvent(PracticePhase.listening),
          );
        } else if (status == 'done') {
          _practiceScreenBloc.add(
            PracticeScreenSetPhaseEvent(PracticePhase.idle),
          );
        }
      };
      _speechToTextController.errorListener = (error) {
        _practiceScreenBloc.add(
          PracticeScreenSetPhaseEvent(PracticePhase.idle),
        );
        print('Listening Error: $error');
      };
      await _speechToTextController.listen(
        onResult: _onRecognizedText,
        listenOptions: SpeechListenOptions(
          listenFor: const Duration(minutes: 1),
          pauseFor: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('Error Starting Speaking: $e');
      if (!mounted) return;
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text('Error Starting Speaking'),
        description: Text(e.toString()),
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _stopSpeaking() async {
    try {
      await _speechToTextController.stop();
    } catch (e) {
      print('Error Stopping Speaking: $e');
      if (!mounted) return;
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text('Error Stopping Speaking'),
        description: Text(e.toString()),
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  void _debounceToggleSpeaking() {
    final isListening =
        _practiceScreenBloc.state.phase == PracticePhase.listening;
    if (isListening) {
      _debouncer.run(() => _stopSpeaking());
    } else {
      _debouncer.run(() => _startSpeaking());
    }
  }

  void _onRecognizedText(SpeechRecognitionResult result) {
    if (!mounted) return;
    _recognizedText.value = result.recognizedWords;

    if (_hasActiveMatcher) {
      _activeMatchResult.value = _matchers[_activeTurnId!]!.update(
        result.recognizedWords,
      );
    }

    if (!result.finalResult || result.recognizedWords.isEmpty) return;

    if (_activeMatchResult.value?.passed != true) {
      _recognizedText.value = null;
      _practiceScreenBloc.add(PracticeScreenSetPhaseEvent(PracticePhase.idle));
      if (_hasActiveMatcher) {
        _matchers[_activeTurnId!]!.reset();
        _activeMatchResult.value = _matchers[_activeTurnId!]!.update('');
      }
      Toastification().show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text('Keep trying!'),
        description: const Text('Match at least 40% of the words to continue.'),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    if (_activeTurnId != null && _activeMatchResult.value != null) {
      _finalMatchResults[_activeTurnId!] = _activeMatchResult.value!;
    }

    final turns = _practiceScreenBloc.state.turns;
    final currentTurn = turns?[_practiceScreenBloc.state.currentTurnIndex];
    if (currentTurn == null) return;

    final nextTurnIndex = _practiceScreenBloc.state.currentTurnIndex + 1;
    if (nextTurnIndex >= (turns?.length ?? 0)) {
      _practiceScreenBloc.add(
        PracticeScreenSetPhaseEvent(PracticePhase.finished),
      );
    } else {
      _practiceScreenBloc.add(
        PracticeScreenSetPhaseEvent(PracticePhase.awaitingContinue),
      );
    }
  }

  void _onEndTurn() {
    Toastification().show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: const Text('Turn ended'),
      description: const Text('The turn has been ended successfully'),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      DialogTurnsListByDialogBloc,
      DialogTurnsListByDialogState
    >(
      listenWhen: (prev, curr) =>
          prev.requestStatus != curr.requestStatus &&
          curr.requestStatus == RequestStatus.success,
      listener: (context, state) async {
        if (state.data == null || state.data!.isEmpty) return;
        _practiceScreenBloc.add(
          PracticeScreenLoadDialogTurnsEvent(turns: state.data!),
        );
        await _insertDialogTurn(turn: state.data!.first, currentTurnIndex: 0);
      },
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
                onPressed: () => context.go('/learn'),
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
                        '${state.currentTurnIndex + 1} of $turnsLength turns',
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
                  child: Chat(
                    currentUserId: 'user1',
                    resolveUser: (UserID id) async =>
                        User(id: id, name: 'John Doe'),
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
                                onPlay: () => _playDialogTurnAudio(turn: turn),
                              );
                            }

                            // Active user turn: rebuilds on every STT word.
                            if (turn.id == _activeTurnId) {
                              return ListenableBuilder(
                                listenable: Listenable.merge([
                                  _recognizedText,
                                  _activeMatchResult,
                                ]),
                                builder: (context, _) => UserMessage(
                                  turn: turn,
                                  index: index,
                                  isPlaying: isPlaying,
                                  onPlay: () =>
                                      _playDialogTurnAudio(turn: turn),
                                  tokens: _activeMatchResult.value?.tokens,
                                ),
                              );
                            }

                            // Completed user turn: static, uses final match result.
                            return UserMessage(
                              turn: turn,
                              index: index,
                              isPlaying: isPlaying,
                              onPlay: () => _playDialogTurnAudio(turn: turn),
                              tokens: _finalMatchResults[turn.id]?.tokens,
                            );
                          },
                      composerBuilder: (context) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                PracticeControlBar(
                  phase: state.phase,
                  isAudioPlaying: state.playingDialogTurnID != null,
                  recognizedText: _recognizedText,
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
