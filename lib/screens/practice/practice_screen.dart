import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_event.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;
import 'package:zingo/models/dialog_turn.dart';
import 'package:zingo/screens/learn/learn-detail/learn_detail_screen.dart';
import 'package:zingo/services/cache_service.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    this.practiceSessionId = '1c11f53a-d653-4e1d-97e2-242e82ebe22b',
    this.dialogId = '13febbdf-a74c-4904-bc3b-c22bdec6a327',
    this.praceticeMode = PracticeMode.readAloud,
    this.dialog,
  });
  final String practiceSessionId;
  final String dialogId;
  final PracticeMode praceticeMode;
  final dialog_model.Dialog? dialog;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  DialogTurnsListByDialogBloc get bloc =>
      context.read<DialogTurnsListByDialogBloc>();

  final _chatController = InMemoryChatController();
  int get currentTurnIndex => _chatController.messages.length - 1;
  String? _playingDialogTurnID;

  final Map<String, File> _audioFiles = {};
  final Map<String, String> _recognizedTexts = {};

  final _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();
  final Set<int> _showContextNote = {};

  String _recognizedText = '';
  bool _speechEnabled = false;
  bool _isEndTurn = false;

  @override
  void initState() {
    super.initState();
    bloc.add(
      DialogTurnsListByDialogFetchEvent(
        payload: DialogTurnsByDialogIdPayload(dialogId: widget.dialogId),
      ),
    );
    _initSpeech();
  }

  Future<void> _insertTurn({required DialogTurn turn}) async {
    await _chatController.insertMessage(
      TextMessage(
        id: turn.id,
        authorId: turn.speaker.value,
        text: turn.line_text,
      ),
    );
  }

  Future<void> _playVoice({required String audioUrl}) async {
    // Make sure the player is stopped and at the beginning
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.pause();
    // Load and play
    await _audioPlayer.setUrl(audioUrl);
    await _audioPlayer.play();
    // Reset and pause
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.pause();
  }

  Future<bool> _playVoiceDialogTurn({required DialogTurn turn}) async {
    if (_audioPlayer.playerState.playing ||
        _playingDialogTurnID != null ||
        turn.tts_model_audio_url == null) {
      return false;
    }
    try {
      var file = _audioFiles[turn.id];
      if (file == null) {
        file = await AudioCacheService.getFileOrDownload(
          turn.tts_model_audio_url!,
        );
        if (!mounted) return false;
        _audioFiles[turn.id] = file;
      }
      setState(() => _playingDialogTurnID = turn.id);
      await _playVoice(audioUrl: file.uri.toString());
    } finally {
      if (mounted) setState(() => _playingDialogTurnID = null);
    }
    return true;
  }

  Future<void> _loadDialogTurns() async {
    final turns = bloc.state.data ?? [];
    if (turns.isEmpty || turns.length <= (currentTurnIndex + 1)) return;

    final currentTurn = turns.elementAt(currentTurnIndex + 1);
    await _insertTurn(turn: currentTurn);

    if (currentTurn.speaker == Speaker.user) return;
    if (currentTurn.speaker == Speaker.ai) {
      await _playVoiceDialogTurn(turn: currentTurn);
      await _loadDialogTurns();
      return;
    }
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) {
        if (error.errorMsg == "error_no_match") {
          Toastification().show(
            context: context,
            type: ToastificationType.warning,
            style: ToastificationStyle.flat,
            title: const Text('Speak to the microphone clearly'),
            description: Text('Make sure your voice is clear and loud'),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        debugPrint('STT error: $error');
        setState(() {});
      },
      onStatus: (status) {
        debugPrint('STT status: $status');
        debugPrint('STT status is listening: ${_speechToText.isListening}');
        debugPrint('STT status has error: ${_speechToText.hasError}');
        debugPrint('STT status has recognized: ${_speechToText.hasRecognized}');
        debugPrint('STT status last status: ${_speechToText.lastStatus}');
        debugPrint(
          'STT status last sound level: ${_speechToText.lastSoundLevel}',
        );
        debugPrint('STT status is available: ${_speechToText.isAvailable}');
        debugPrint("--------------------------------");
        if (status == "done" &&
            (!_speechToText.hasRecognized || _recognizedText.isEmpty) &&
            _speechToText.lastSoundLevel <= 0) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text('No speech recognized'),
            description: Text('Please speak clearly and loudly'),
            autoCloseDuration: const Duration(seconds: 4),
          );
          return;
        }
        setState(() {});
      },
    );
    setState(() {});
  }

  void _toggleSpeechListening() async {
    if (_playingDialogTurnID != null) return;
    final totalTurns =
        bloc.state.data?.length ?? widget.dialog?.conversation_length ?? 0;
    // If no turns, do nothing
    if (totalTurns == 0) return;
    // Retry init speech if not enabled
    if (!_speechEnabled) {
      await _initSpeech();
      return;
    }
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
        // Check if end turn
        final isEndTurn = (currentTurnIndex + 1) == totalTurns;
        if (isEndTurn) {
          setState(() => _isEndTurn = true);
        }
        return;
      }
      if (_speechToText.isNotListening) {
        setState(() {
          _recognizedText = '';
        });
        await _speechToText.listen(
          onResult: _onSpeechResult,
          listenOptions: SpeechListenOptions(
            listenFor: const Duration(minutes: 1),
            pauseFor: const Duration(seconds: 5),
            cancelOnError: true,
          ),
        );
        return;
      }
    } catch (e) {
      debugPrint('STT error: $e');
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text('Error while speaking'),
        description: Text('Please try again'),
        autoCloseDuration: const Duration(seconds: 4),
      );
    } finally {
      setState(() {});
    }
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    final currentTurn = bloc.state.data?[currentTurnIndex];
    setState(() {
      _recognizedText = result.recognizedWords;
      _recognizedTexts[currentTurn!.id] = result.recognizedWords;
    });

    print("Current turn index: $currentTurnIndex");
    if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
      Toastification().show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: const Text('Speech recognized'),
        description: Text('Loading next turn'),
        autoCloseDuration: const Duration(seconds: 4),
      );
      await _loadDialogTurns();
    }
  }

  @override
  void dispose() {
    _speechToText.stop();
    _chatController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      DialogTurnsListByDialogBloc,
      DialogTurnsListByDialogState
    >(
      listener: (context, state) async {
        if (state.requestStatus == RequestStatus.success &&
            state.data != null) {
          await _loadDialogTurns();
        }
      },
      builder: (context, state) {
        final turns = state.data ?? [];
        final totalTurns =
            ((state.data?.length ?? widget.dialog?.conversation_length ?? 1) /
                    2)
                .ceil();
        final currentTurn = ((currentTurnIndex + 1) / 2).ceil();
        final progress = (currentTurn + 1) / (totalTurns + 1);
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              onPressed: () => context.go("/learn"),
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
                        widget.dialog?.title ?? "N/A",
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$currentTurn of $totalTurns turns",
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
                          final turn = turns.isNotEmpty ? turns[index] : null;
                          final isPlaying =
                              _playingDialogTurnID == turn?.id &&
                              _playingDialogTurnID != null;

                          if (turn?.speaker == Speaker.ai) {
                            return _AiMessage(
                              turn: turn,
                              index: index,
                              isPlaying: isPlaying,
                              showContextNote: _showContextNote.contains(index),
                              onPlay: () => _playVoiceDialogTurn(turn: turn!),
                              onToggleContextNote: () => setState(() {
                                _showContextNote.contains(index)
                                    ? _showContextNote.remove(index)
                                    : _showContextNote.add(index);
                              }),
                            );
                          }
                          return _UserMessage(
                            turn: turn,
                            index: index,
                            isPlaying: isPlaying,
                            showContextNote: _showContextNote.contains(index),
                            onPlay: () => _playVoiceDialogTurn(turn: turn!),
                            recognizedText: turn != null
                                ? _recognizedTexts[turn.id] ?? ''
                                : '',
                            onToggleContextNote: () => setState(() {
                              _showContextNote.contains(index)
                                  ? _showContextNote.remove(index)
                                  : _showContextNote.add(index);
                            }),
                          );
                        },
                    composerBuilder: (context) => const SizedBox.shrink(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 4,
                  children: [
                    if (_recognizedText.isNotEmpty) Text(_recognizedText),
                    IconButton.filledTonal(
                      onPressed: (_isEndTurn || !_speechEnabled)
                          ? null
                          : _toggleSpeechListening,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          _speechToText.isListening
                              ? AppColors.accent
                              : AppColors.accentLight,
                        ),
                      ),
                      icon: Icon(
                        _speechToText.isListening
                            ? Icons.mic
                            : Icons.mic_none_outlined,
                        size: 40,
                      ),
                    ),
                    Text(
                      _speechToText.isListening
                          ? 'Listening... tap to stop'
                          : 'Tap to speak',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AiMessage extends StatelessWidget {
  const _AiMessage({
    required this.turn,
    required this.index,
    required this.isPlaying,
    required this.showContextNote,
    required this.onPlay,
    required this.onToggleContextNote,
  });

  final DialogTurn? turn;
  final int index;
  final bool isPlaying;
  final bool showContextNote;
  final VoidCallback onPlay;
  final VoidCallback onToggleContextNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      turn?.line_text ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Transform.translate(
                      offset: const Offset(-4, 0),
                      child: Row(
                        children: [
                          IconButton.filled(
                            tooltip: 'Play audio',
                            onPressed: onPlay,
                            icon: isPlaying
                                ? Lottie.asset(
                                    'assets/sound_voice_waves.json',
                                    width: 20,
                                    height: 20,
                                    repeat: true,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.volume_up_outlined,
                                    size: 20,
                                  ),
                          ),
                          IconButton.outlined(
                            tooltip: 'Translate',
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.white,
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.translate_outlined,
                              size: 20,
                            ),
                          ),
                          if (turn?.context_note != null)
                            IconButton.outlined(
                              tooltip: 'Context note',
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  showContextNote
                                      ? AppColors.primaryContainer
                                      : AppColors.white,
                                ),
                              ),
                              onPressed: onToggleContextNote,
                              icon: const Icon(Icons.info_outline, size: 20),
                            ),
                        ],
                      ),
                    ),
                    if (showContextNote && turn?.context_note != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        turn!.context_note!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({
    required this.turn,
    required this.index,
    required this.isPlaying,
    required this.showContextNote,
    required this.onPlay,
    required this.onToggleContextNote,
    required this.recognizedText,
  });

  final DialogTurn? turn;
  final int index;
  final bool isPlaying;
  final bool showContextNote;
  final VoidCallback onPlay;
  final VoidCallback onToggleContextNote;
  final String recognizedText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children:
                            turn?.line_text
                                .split(" ")
                                .map((word) {
                                  final cleanWord = word.replaceAll(
                                    RegExp(r'[^a-zA-Z0-9]'),
                                    '',
                                  );
                                  final cleanRecognizedText = recognizedText
                                      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
                                  final isInRecognizedText =
                                      cleanWord.isNotEmpty &&
                                      cleanRecognizedText
                                          .toLowerCase()
                                          .contains(cleanWord.toLowerCase());
                                  return [
                                    TextSpan(
                                      text: word,
                                      style: isInRecognizedText
                                          ? Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              color: AppColors.scoreHigh,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationStyle:
                                                  TextDecorationStyle.dashed,
                                            )
                                          : Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationStyle:
                                                  TextDecorationStyle.dashed,
                                            ),
                                    ),
                                    TextSpan(text: "  "),
                                  ];
                                })
                                .expand((e) => e)
                                .toList() ??
                            [],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Transform.translate(
                      offset: const Offset(-4, 0),
                      child: Row(
                        children: [
                          IconButton.filled(
                            tooltip: 'Play audio',
                            onPressed: onPlay,
                            icon: isPlaying
                                ? Lottie.asset(
                                    'assets/sound_voice_waves.json',
                                    width: 20,
                                    height: 20,
                                    repeat: true,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.volume_up_outlined,
                                    size: 20,
                                  ),
                          ),
                          IconButton.outlined(
                            tooltip: 'Translate',
                            onPressed: () {},
                            icon: const Icon(
                              Icons.translate_outlined,
                              size: 20,
                            ),
                          ),
                          if (turn?.context_note != null)
                            IconButton.outlined(
                              tooltip: 'Context note',
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  showContextNote
                                      ? AppColors.primaryContainer
                                      : AppColors.white,
                                ),
                              ),
                              onPressed: onToggleContextNote,
                              icon: const Icon(Icons.info_outline, size: 20),
                            ),
                        ],
                      ),
                    ),
                    if (showContextNote && turn?.context_note != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        turn!.context_note!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.person_outline,
              size: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
