import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
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
  final _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();
  final Set<int> _showContextNote = {};
  int _isPlayingIndex = -1;
  bool _speechEnabled = false;
  String _recognizedText = '';
  int _currentTurnIndex = 0;
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

  Future<void> _loadNextTurn() async {
    final data = bloc.state.data;
    if (data == null || data.isEmpty) return;
    if (_currentTurnIndex + 1 >= data.length) {
      setState(() => _isEndTurn = true);
      return;
    }
    final turn = data[_currentTurnIndex];
    final nextTurn = data[_currentTurnIndex + 1];
    await _chatController.insertMessage(
      TextMessage(
        id: turn.id,
        authorId: turn.speaker.value,
        text: turn.line_text,
      ),
    );
    if (turn.speaker == Speaker.ai) {
      await _playSound(_currentTurnIndex);
    }
    await _chatController.insertMessage(
      TextMessage(
        id: nextTurn.id,
        authorId: nextTurn.speaker.value,
        text: nextTurn.line_text,
      ),
    );
    setState(() => _currentTurnIndex += 2);
  }

  Future<void> _playSound(int index) async {
    if (_isPlayingIndex != -1) return;
    setState(() => _isPlayingIndex = index);
    if (_audioPlayer.playerState.playing) return;
    if (bloc.state.data == null || bloc.state.data!.isEmpty) return;
    final turn = bloc.state.data![index];
    final file = await AudioCacheService.getFileOrDownload(
      turn.tts_model_audio_url ?? '',
    );
    await _audioPlayer.setUrl(file.uri.toString());
    await _audioPlayer.play();
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.pause();
    setState(() => _isPlayingIndex = -1);
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) => debugPrint('STT error: $error'),
      onStatus: (status) {
        if (mounted) setState(() {});
      },
    );
    if (mounted) setState(() {});
  }

  void _toggleListening() async {
    if (_isPlayingIndex != -1) return;
    if (_isEndTurn) return;
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
        await _loadNextTurn();
      } else {
        setState(() => _recognizedText = '');
        await _speechToText.listen(
          onResult: _onSpeechResult,
          listenOptions: SpeechListenOptions(
            listenFor: const Duration(minutes: 2),
            pauseFor: const Duration(seconds: 5),
            cancelOnError: false,
          ),
        );
      }
    } catch (e) {
      debugPrint('STT error: $e');
    }
    if (mounted) setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _recognizedText = result.recognizedWords);
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
          await _loadNextTurn();
        }
      },
      builder: (context, state) {
        final turns = state.data ?? [];
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
                      "1 of ${widget.dialog?.conversation_length ?? (((turns.length + 1) / 2)).round()} turns",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value:
                      1 /
                      (widget.dialog?.conversation_length ??
                          (turns.length + 1)),
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
                          if (turn?.speaker == Speaker.ai) {
                            return _AiMessage(
                              turn: turn,
                              index: index,
                              isPlaying: _isPlayingIndex == index,
                              showContextNote: _showContextNote.contains(index),
                              onPlay: () => _playSound(index),
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
                            isPlaying: _isPlayingIndex == index,
                            showContextNote: _showContextNote.contains(index),
                            onPlay: () => _playSound(index),
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
                          : _toggleListening,
                      style: _speechToText.isListening
                          ? ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.accent,
                              ),
                            )
                          : null,
                      icon: Icon(
                        _speechToText.isListening
                            ? Icons.mic
                            : Icons.mic_outlined,
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
