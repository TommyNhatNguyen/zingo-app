import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;
import 'package:zingo/models/dialog_turn.dart';
import 'package:zingo/screens/learn/learn-detail/learn_detail_screen.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_bloc.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';

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
  // // Services — not state, live locally
  final _chatController = InMemoryChatController();
  // final _audioPlayer = AudioPlayer();
  // SpeechToText get _speechToText => SpeechToTextService.instance;

  // // Tracks message count so the submit button rebuilds when turns are inserted.
  // final _messageCount = ValueNotifier<int>(0);

  // // Context note visibility is pure UI — no need in the bloc
  // final Set<int> _showContextNote = {};

  // PracticeScreenBloc get bloc => context.read<PracticeScreenBloc>();
  // DialogTurnsListByDialogBloc get dialogTurnsBloc =>
  //     context.read<DialogTurnsListByDialogBloc>();

  // int get currentTurnIndex => _chatController.messages.length - 1;

  @override
  void initState() {
    super.initState();
    // dialogTurnsBloc.add(
    //   DialogTurnsListByDialogFetchEvent(
    //     payload: DialogTurnsByDialogIdPayload(dialogId: widget.dialogId),
    //   ),
    // );
    // _initSpeech();
  }

  @override
  void dispose() {
    // _chatController.dispose();
    // _audioPlayer.dispose();
    // _messageCount.dispose();
    super.dispose();
  }

  void _insertDialogTurn() {}
  void _playDialogTurnAudio() {}
  void _stopDialogTurnAudio() {}
  void _startSpeaking() {}
  void _stopSpeaking() {}
  void _continueToNextDialogTurn() {}

  // -------------------------------------------------------------------------
  // Audio / chat
  // -------------------------------------------------------------------------

  // Future<void> _insertTurn({required DialogTurn turn}) async {
  //   await _chatController.insertMessage(
  //     TextMessage(
  //       id: turn.id,
  //       authorId: turn.speaker.value,
  //       text: turn.line_text,
  //     ),
  //   );
  //   _messageCount.value = _chatController.messages.length;
  // }

  // Future<void> _playVoice({required String audioUrl}) async {
  //   await _audioPlayer.seek(Duration.zero);
  //   await _audioPlayer.pause();
  //   await _audioPlayer.setUrl(audioUrl);
  //   await _audioPlayer.play();
  //   await _audioPlayer.seek(Duration.zero);
  //   await _audioPlayer.pause();
  // }

  // Future<bool> _playVoiceDialogTurn({required DialogTurn turn}) async {
  //   if (_audioPlayer.playerState.playing ||
  //       bloc.state.playingDialogTurnID != null ||
  //       turn.tts_model_audio_url == null) {
  //     return false;
  //   }
  //   try {
  //     var file = bloc.state.audioFiles?[turn.id];
  //     if (file == null) {
  //       final downloaded = await AudioCacheService.getFileOrDownload(
  //         turn.tts_model_audio_url!,
  //       );
  //       if (!mounted) return false;
  //       file = downloaded;
  //       bloc.change((s) => s.copyWith(
  //         audioFiles: {...?s.audioFiles, turn.id: downloaded},
  //       ));
  //     }
  //     bloc.change((s) => s.copyWith(playingDialogTurnID: turn.id));
  //     await _playVoice(audioUrl: file.uri.toString());
  //   } finally {
  //     if (mounted) {
  //       bloc.change((s) => s.copyWith(clearPlayingDialogTurnID: true));
  //     }
  //   }
  //   return true;
  // }

  // Future<void> _loadDialogTurns(List<DialogTurn> turns) async {
  //   if (turns.isEmpty || turns.length <= (currentTurnIndex + 1)) return;

  //   final nextTurn = turns.elementAt(currentTurnIndex + 1);
  //   await _insertTurn(turn: nextTurn);

  //   if (nextTurn.speaker == Speaker.user) return;
  //   if (nextTurn.speaker == Speaker.ai) {
  //     await _playVoiceDialogTurn(turn: nextTurn);
  //     await _loadDialogTurns(turns);
  //   }
  // }

  // -------------------------------------------------------------------------
  // Speech
  // -------------------------------------------------------------------------

  // Future<void> _initSpeech() async {
  //   if (SpeechToTextService.instance.isAvailable) {
  //     if (mounted) bloc.change((s) => s.copyWith(speechEnabled: true));
  //     return;
  //   }
  //   final enabled = await SpeechToTextService.initialize(
  //     onError: (error) {
  //       debugPrint('STT error: $error');
  //     },
  //     onStatus: (status) {
  //       debugPrint(
  //         'STT $status | listening:${_speechToText.isListening}'
  //         ' | recognized:${_speechToText.hasRecognized}'
  //         ' | sound:${_speechToText.lastSoundLevel}',
  //       );
  //       // Guard: skip toast during warm-up (no turns loaded yet).
  //       final onUserTurn = currentTurnIndex >= 0;
  //       if (status == 'done' &&
  //           onUserTurn &&
  //           !_speechToText.hasRecognized &&
  //           bloc.state.recognizedText.isEmpty &&
  //           _speechToText.lastSoundLevel <= 0) {
  //         Toastification().show(
  //           context: context,
  //           type: ToastificationType.error,
  //           style: ToastificationStyle.flat,
  //           title: const Text('No speech recognized'),
  //           description: const Text('Please speak clearly and loudly'),
  //           autoCloseDuration: const Duration(seconds: 4),
  //         );
  //       }
  //       bloc.change((s) => s.copyWith(isListening: _speechToText.isListening));
  //     },
  //   );

  //   if (enabled) {
  //     // Pre-warm AVAudioEngine so the first user-triggered listen() starts instantly.
  //     await _speechToText.listen(
  //       onResult: (_) {},
  //       listenOptions: SpeechListenOptions(
  //         listenFor: const Duration(seconds: 1),
  //         pauseFor: const Duration(seconds: 1),
  //       ),
  //     );
  //     await _speechToText.stop();
  //   }

  //   if (mounted) {
  //     bloc.change((s) => s.copyWith(speechEnabled: enabled));
  //   }
  // }

  // void _toggleSpeechListening() async {
  //   if (bloc.state.playingDialogTurnID != null) return;
  //   final totalTurns =
  //       bloc.state.turns?.length ?? widget.dialog?.conversation_length ?? 0;
  //   if (totalTurns == 0) return;

  //   try {
  //     if (_speechToText.isListening) {
  //       // Manual stop: go straight to Finish if on the last turn.
  //       if ((currentTurnIndex + 1) == totalTurns) {
  //         bloc.change((s) => s.copyWith(isEndTurn: true));
  //       }
  //       bloc.change((s) => s.copyWith(recognizedText: ''));
  //       await _speechToText.stop();
  //       return;
  //     }
  //     if (_speechToText.isNotListening) {
  //       await _speechToText.listen(
  //         onResult: _onSpeechResult,
  //         listenOptions: SpeechListenOptions(
  //           listenFor: const Duration(minutes: 1),
  //           pauseFor: const Duration(seconds: 5),
  //           cancelOnError: true,
  //           enableHapticFeedback: true,
  //         ),
  //       );
  //       bloc.change((s) => s.copyWith(isListening: true));
  //       return;
  //     }
  //   } catch (e) {
  //     debugPrint('STT toggle error: $e');
  //     Toastification().show(
  //       context: context,
  //       type: ToastificationType.error,
  //       style: ToastificationStyle.flat,
  //       title: const Text('Error while speaking'),
  //       description: const Text('Please try again'),
  //       autoCloseDuration: const Duration(seconds: 4),
  //     );
  //   }
  // }

  // Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
  //   if (currentTurnIndex < 0) return;
  //   final currentTurn = bloc.state.turns?[currentTurnIndex];
  //   if (currentTurn == null) return;

  //   bloc.change((s) => s.copyWith(
  //     recognizedText: result.recognizedWords,
  //     recognizedTexts: {...?s.recognizedTexts, currentTurn.id: result.recognizedWords},
  //   ));

  //   if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
  //     // Auto-stop after recognition so the Continue button can appear.
  //     await _speechToText.stop();
  //     if (mounted) bloc.change((s) => s.copyWith(recognizedText: ''));
  //   }
  // }

  // -------------------------------------------------------------------------
  // Submit button
  // -------------------------------------------------------------------------

  // Widget _buildSubmitButton() {
  //   final turns = bloc.state.turns ?? [];

  //   if (bloc.state.isEndTurn == true) {
  //     return FilledButton.icon(
  //       style: ButtonStyle(
  //         backgroundColor: WidgetStateProperty.all(AppColors.scoreHigh),
  //       ),
  //       icon: const Icon(Icons.check_circle_outline),
  //       onPressed: () => context.go('/learn'),
  //       label: const Text('Finish practice'),
  //     );
  //   }

  //   final currentTurn = (turns.isNotEmpty && currentTurnIndex >= 0)
  //       ? turns.elementAt(currentTurnIndex)
  //       : null;
  //   final isPracticed =
  //       currentTurn != null &&
  //       bloc.state.recognizedTexts?[currentTurn.id]?.isNotEmpty == true;

  //   if (isPracticed &&
  //       bloc.state.recognizedText.isEmpty &&
  //       bloc.state.playingDialogTurnID == null) {
  //     return FilledButton(
  //       style: ButtonStyle(
  //         backgroundColor: WidgetStateProperty.all(AppColors.primary),
  //       ),
  //       onPressed: () async {
  //         if ((currentTurnIndex + 1) >= turns.length) {
  //           bloc.change((s) => s.copyWith(isEndTurn: true));
  //           return;
  //         }
  //         await _loadDialogTurns(turns);
  //       },
  //       child: const Text('Continue'),
  //     );
  //   }

  //   final isAllowSpeak =
  //       bloc.state.speechEnabled && bloc.state.playingDialogTurnID == null;
  //   return IconButton.filled(
  //     onPressed: isAllowSpeak ? _toggleSpeechListening : null,
  //     style: ButtonStyle(
  //       backgroundColor: WidgetStateProperty.all(
  //         isAllowSpeak ? AppColors.primary : AppColors.primaryLight,
  //       ),
  //     ),
  //     icon: bloc.state.isListening
  //         ? Lottie.asset(
  //             'assets/sound_voice_waves.json',
  //             width: 40,
  //             height: 40,
  //             repeat: true,
  //             fit: BoxFit.cover,
  //           )
  //         : Icon(isAllowSpeak ? Icons.mic : Icons.mic_off, size: 40),
  //   );
  // }

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
                state.data != null) {}
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
                            // final turn = turns.isNotEmpty ? turns[index] : null;
                            // final isPlaying =
                            //     state.playingDialogTurnID != null &&
                            //     state.playingDialogTurnID == turn?.id;

                            return const SizedBox.shrink();

                            // if (turn?.speaker == Speaker.ai) {
                            //   return _AiMessage(
                            //     turn: turn,
                            //     index: index,
                            //     isPlaying: isPlaying,
                            //     showContextNote: _showContextNote.contains(
                            //       index,
                            //     ),
                            //     onPlay: () => _playVoiceDialogTurn(turn: turn!),
                            //     onToggleContextNote: () => setState(() {
                            //       _showContextNote.contains(index)
                            //           ? _showContextNote.remove(index)
                            //           : _showContextNote.add(index);
                            //     }),
                            //   );
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
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  height: 100,
                  width: double.infinity,
                  // child: _buildSubmitButton(),
                  child: const SizedBox.shrink(),
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
