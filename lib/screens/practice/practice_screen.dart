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
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;
import 'package:zingo/models/dialog_turn.dart';
import 'package:zingo/screens/learn/learn-detail/learn_detail_screen.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_bloc.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';
import 'package:zingo/services/cache_service.dart';
import 'package:zingo/services/speech_to_text_service.dart';
import 'package:zingo/utils/debounce_util.dart';

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
  late final InMemoryChatController _chatController;
  late final PracticeScreenBloc _practiceScreenBloc;
  late final AudioPlayer _audioPlayer;
  final ValueNotifier<String?> _recognizedText = ValueNotifier<String?>(null);
  SpeechToText get _speechToTextController => SpeechToTextService.instance;
  final DebounceUtil _debouncer = DebounceUtil(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController();
    _practiceScreenBloc = context.read<PracticeScreenBloc>();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      PracticeScreenInsertDialogTurnEvent(
        turn: turn,
        currentTurnIndex: currentTurnIndex,
      ),
    );
    if (turn.speaker == Speaker.user) return;

    final nextTurnIndex = currentTurnIndex + 1;
    if (nextTurnIndex >= _practiceScreenBloc.state.turns!.length) return;
    final nextTurn = _practiceScreenBloc.state.turns?[nextTurnIndex];
    if (turn.speaker == Speaker.ai) {
      if (nextTurn == null) return;
      await _playDialogTurnAudio(turn: turn);
      _insertDialogTurn(turn: nextTurn, currentTurnIndex: nextTurnIndex);
    }
  }

  Future<void> _playAudio({required String audioUrl}) async {
    await _audioPlayer.setUrl(audioUrl);
    await _audioPlayer.play();
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
  }

  Future<void> _playDialogTurnAudio({required DialogTurn turn}) async {
    if (_practiceScreenBloc.state.playingDialogTurnID == turn.id) return;

    if (turn.tts_model_audio_url == null) {
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text('Error'),
        description: const Text("This turn does not have an audio yet!"),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    // Claim the ID before pausing so playingDialogTurnID never has a null gap
    // between switching turns (which would flash the mic button enabled).
    _practiceScreenBloc.add(
      PracticeScreenPlayDialogTurnAudioEvent(
        turn: turn,
        clearPlayingDialogTurnID: false,
      ),
    );

    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);

    final file = await AudioCacheService.instance.getSingleFile(
      turn.tts_model_audio_url!,
    );
    await _playAudio(audioUrl: file.uri.toString());

    // Only clear if this call is still the owner — a newer tap may have already
    // claimed the ID, in which case clearing it would cause the same flash.
    if (_practiceScreenBloc.state.playingDialogTurnID == turn.id) {
      _practiceScreenBloc.add(
        PracticeScreenPlayDialogTurnAudioEvent(
          turn: null,
          clearPlayingDialogTurnID: true,
        ),
      );
    }
  }

  Future<void> _startSpeaking() async {
    try {
      _practiceScreenBloc.add(PracticeScreenStartListeningEvent());
      await _speechToTextController.listen(
        onResult: _onRecognizedText,
        listenOptions: SpeechListenOptions(
          listenFor: const Duration(minutes: 1),
          pauseFor: const Duration(seconds: 5),
        ),
      );
      _speechToTextController.statusListener = (status) {
        print('Listening Status: $status');
        if (status == "done" && _practiceScreenBloc.state.isListening) {
          _practiceScreenBloc.add(PracticeScreenStopListeningEvent());
          Toastification().show(
            context: context,
            type: ToastificationType.warning,
            style: ToastificationStyle.flat,
            title: const Text('Not recognized'),
            description: Text("Please try to speak louder"),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        if (status == "done" && !_practiceScreenBloc.state.isListening) {
          if (_recognizedText.value == null) {
            Toastification().show(
              context: context,
              type: ToastificationType.warning,
              style: ToastificationStyle.flat,
              title: const Text('Not recognized'),
              description: Text("Please try to speak louder"),
              autoCloseDuration: const Duration(seconds: 4),
            );
          }
        }
      };
      _speechToTextController.errorListener = (error) {
        print('Listening Error: $error');
      };
      print("--------------------------------");
    } catch (e) {
      print('Error Starting Speaking: ${e.toString()}');
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
      _practiceScreenBloc.add(PracticeScreenStopListeningEvent());
      await _speechToTextController.stop();
    } catch (e) {
      print('Error Stopping Speaking: ${e.toString()}');
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

  Future<void> _debounceToggleSpeaking() async {
    if (_practiceScreenBloc.state.isListening) {
      _debouncer.run(() async {
        await _stopSpeaking();
      });
    } else {
      _debouncer.run(() async {
        await _startSpeaking();
      });
    }
  }

  void _onRecognizedText(SpeechRecognitionResult result) {
    _recognizedText.value = result.recognizedWords;
    if (result.finalResult &&
        !_practiceScreenBloc.state.isListening &&
        result.recognizedWords.isNotEmpty) {
      final currentTurn = _practiceScreenBloc
          .state
          .turns?[_practiceScreenBloc.state.currentTurnIndex];
      if (currentTurn == null) return;
      _practiceScreenBloc.add(
        PracticeScreenRecognizedTextEvent(
          recognizedText: _recognizedText.value!,
          dialogTurnId: currentTurn.id,
        ),
      );
      _practiceScreenBloc.add(
        PracticeScreenShouldPlayNextDialogTurnEvent(
          shouldPlayNextDialogTurn: true,
        ),
      );
    }
  }

  Future<void> _continueToNextDialogTurn() async {
    final nextTurnIndex = _practiceScreenBloc.state.currentTurnIndex + 1;
    if (nextTurnIndex >= _practiceScreenBloc.state.turns!.length) return;
    final nextTurn = _practiceScreenBloc.state.turns?[nextTurnIndex];
    if (nextTurn == null) return;
    _practiceScreenBloc.add(
      PracticeScreenShouldPlayNextDialogTurnEvent(
        shouldPlayNextDialogTurn: false,
      ),
    );
    _recognizedText.value = null;
    await _insertDialogTurn(turn: nextTurn, currentTurnIndex: nextTurnIndex);
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DialogTurnsListByDialogBloc, DialogTurnsListByDialogState>(
          listener: (context, state) async {
            if (state.requestStatus == RequestStatus.success &&
                state.data != null) {
              if (state.data!.isEmpty) return;
              _practiceScreenBloc.add(
                PracticeScreenLoadDialogTurnsEvent(turns: state.data!),
              );
              final firstTurn = state.data!.first;
              await _insertDialogTurn(turn: firstTurn, currentTurnIndex: 0);
            }
          },
        ),
        BlocListener<PracticeScreenBloc, PracticeScreenViewState>(
          listenWhen: (previous, current) {
            return current.turns?.isNotEmpty ?? false;
          },
          listener: (context, state) {
            if (!state.isListening && _recognizedText.value != null) {}
          },
        ),
      ],
      child: BlocBuilder<PracticeScreenBloc, PracticeScreenViewState>(
        builder: (context, state) {
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
                        '${0} of ${0} turns',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: 0,
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
                            // if (turn.speaker == Speaker.ai) {
                            return _AiMessage(
                              turn: turn,
                              index: index,
                              isPlaying: isPlaying,
                              onPlay: () => _playDialogTurnAudio(turn: turn),
                            );
                            // }
                            // return _UserMessage(
                            //   turn: turn,
                            //   index: index,
                            //   isPlaying: isPlaying,
                            //   showContextNote: _showContextNote.contains(index),
                            //   onPlay: () => _playVoiceDialogTurn(turn: turn!),
                            //   recognizedText: turn != null
                            //       ? (state.recognizedTexts?[turn.id] ?? '')
                            //       : '',
                            //   onToggleContextNote: () => setState(() {
                            //     _showContextNote.contains(index)
                            //         ? _showContextNote.remove(index)
                            //         : _showContextNote.add(index);
                            //   }),
                            // );
                          },
                      composerBuilder: (context) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                BlocBuilder<SpeechToTextBloc, SpeechToTextState>(
                  builder: (context, speechToTextState) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      height: 100,
                      width: double.infinity,
                      child: state.shouldPlayNextDialogTurn
                          ? FilledButton(
                              onPressed: _continueToNextDialogTurn,
                              child: const Text("Continue"),
                            )
                          : IconButton.filled(
                              tooltip: 'Start speaking',
                              onPressed:
                                  (!speechToTextState.isEnabled ||
                                      state.playingDialogTurnID != null)
                                  ? null
                                  : _debounceToggleSpeaking,
                              icon:
                                  (!speechToTextState.isEnabled ||
                                      state.playingDialogTurnID != null)
                                  ? Icon(Icons.mic_off, size: 40)
                                  : state.isListening
                                  ? Lottie.asset(
                                      'assets/sound_voice_waves.json',
                                      width: 40,
                                      height: 40,
                                      repeat: true,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.mic, size: 40),
                            ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _recognizedText,
                  builder: (context, value, child) {
                    return Text(_recognizedText.value ?? '');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Message widgets
// ---------------------------------------------------------------------------

class _AiMessage extends StatefulWidget {
  const _AiMessage({
    required this.turn,
    required this.index,
    required this.isPlaying,
    required this.onPlay,
  });

  final DialogTurn? turn;
  final int index;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  State<_AiMessage> createState() => _AiMessageState();
}

class _AiMessageState extends State<_AiMessage> {
  bool _isShowContextNote = false;

  void _toggleContextNote() {
    setState(() {
      _isShowContextNote = !_isShowContextNote;
    });
  }

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
                      widget.turn?.line_text ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Transform.translate(
                      offset: const Offset(-4, 0),
                      child: Row(
                        children: [
                          IconButton.filled(
                            tooltip: 'Play audio',
                            onPressed: widget.onPlay,
                            icon: widget.isPlaying
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
                          if (widget.turn?.context_note != null)
                            IconButton.outlined(
                              tooltip: 'Context note',
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  _isShowContextNote
                                      ? AppColors.primaryContainer
                                      : AppColors.white,
                                ),
                              ),
                              onPressed: _toggleContextNote,
                              icon: const Icon(Icons.info_outline, size: 20),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isShowContextNote
                        ? Text(
                            widget.turn?.context_note ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          )
                        : const SizedBox.shrink(),
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
                                .split(' ')
                                .map((word) {
                                  final cleanWord = word.replaceAll(
                                    RegExp(r'[^a-zA-Z0-9]'),
                                    '',
                                  );
                                  final cleanRecognized = recognizedText
                                      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
                                  final matched =
                                      cleanWord.isNotEmpty &&
                                      cleanRecognized.toLowerCase().contains(
                                        cleanWord.toLowerCase(),
                                      );
                                  return [
                                    TextSpan(
                                      text: word,
                                      style: matched
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
                                    const TextSpan(text: '  '),
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
