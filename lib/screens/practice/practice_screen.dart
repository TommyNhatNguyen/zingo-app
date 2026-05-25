import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
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
  final List<AudioPlayer> _audioPlayers = [];
  final List<bool> _isPlaying = [];
  final Set<int> _showContextNote = {};
  @override
  void initState() {
    super.initState();
    bloc.add(
      DialogTurnsListByDialogFetchEvent(
        payload: DialogTurnsByDialogIdPayload(
          dialogId: widget.dialogId ?? '13febbdf-a74c-4904-bc3b-c22bdec6a327',
        ),
      ),
    );
    print(widget.dialog);
  }

  void _toggleAudio(int index) async {
    final hasPlaying = _isPlaying.isNotEmpty && _isPlaying.any((item) => item);
    if (index >= _isPlaying.length || _isPlaying[index] || hasPlaying) {
      return;
    } else {
      setState(() {
        _isPlaying[index] = !_isPlaying[index];
      });
      await _audioPlayers[index].play();
      await _audioPlayers[index].pause();
      await _audioPlayers[index].seek(Duration.zero);
      setState(() {
        _isPlaying[index] = !_isPlaying[index];
      });
    }
  }

  Future<void> _initAudioPlayer(List<DialogTurn> turns) async {
    final audioPlayers = await Future.wait(
      turns.map((turn) async {
        final file = await AudioCacheService.getFileOrDownload(
          turn.tts_model_audio_url ?? '',
        );
        final audioPlayer = AudioPlayer();
        await audioPlayer.setUrl(file.uri.toString());
        return audioPlayer;
      }),
    );
    setState(() {
      _audioPlayers.addAll(audioPlayers);
      _isPlaying.addAll(List.filled(audioPlayers.length, false));
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    for (var audioPlayer in _audioPlayers) {
      audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      DialogTurnsListByDialogBloc,
      DialogTurnsListByDialogState
    >(
      listener: (context, state) async {
        if (state.requestStatus == RequestStatus.success) {
          if (state.data != null) {
            await _chatController.insertAllMessages(
              state.data!
                  .map(
                    (turn) => TextMessage(
                      id: turn.id,
                      authorId: turn.speaker.value,
                      text: turn.line_text,
                    ),
                  )
                  .toList(),
            );
            await _initAudioPlayer(state.data!);
          }
        }
      },
      builder: (context, state) {
        final turns = state.data ?? [];
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              onPressed: () => context.go("/learn"),
              icon: Icon(Icons.arrow_back),
            ),
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "${1} of ${widget.dialog?.conversation_length ?? (((turns.length + 1) / 2)).round()} turns",
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
          body: Chat(
            currentUserId: 'user1',
            resolveUser: (UserID id) async {
              return User(id: id, name: 'John Doe');
            },
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
                    final hasAudioPlayers = _audioPlayers.isNotEmpty;
                    if (turn?.speaker == Speaker.ai) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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
                                    children: [
                                      Text(
                                        turn?.line_text ?? '',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Transform.translate(
                                            offset: Offset(-4, 0),
                                            child: Row(
                                              children: [
                                                IconButton.filled(
                                                  tooltip: 'Play audio',
                                                  onPressed: () =>
                                                      _toggleAudio(index),
                                                  icon:
                                                      (hasAudioPlayers
                                                          ? !_isPlaying[index]
                                                          : true)
                                                      ? Icon(
                                                          Icons
                                                              .volume_up_outlined,
                                                          size: 20,
                                                        )
                                                      : Lottie.asset(
                                                          'assets/sound_voice_waves.json',
                                                          width: 20,
                                                          height: 20,
                                                          repeat: true,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                IconButton.outlined(
                                                  tooltip: 'Translate',
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all(
                                                          AppColors.white,
                                                        ),
                                                  ),
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.translate_outlined,
                                                    size: 20,
                                                  ),
                                                ),
                                                if (turn?.context_note != null)
                                                  IconButton.outlined(
                                                    tooltip: 'Context note',
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            _showContextNote
                                                                    .contains(
                                                                      index,
                                                                    )
                                                                ? AppColors
                                                                      .primaryContainer
                                                                : AppColors
                                                                      .white,
                                                          ),
                                                    ),
                                                    onPressed: () => setState(
                                                      () {
                                                        _showContextNote
                                                                .contains(index)
                                                            ? _showContextNote
                                                                  .remove(index)
                                                            : _showContextNote
                                                                  .add(index);
                                                      },
                                                    ),
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 20,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_showContextNote.contains(index) &&
                                          turn?.context_note != null) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          turn!.context_note!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
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
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                                  children: [
                                    Text(
                                      turn?.line_text ?? '',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Transform.translate(
                                          offset: Offset(-4, 0),
                                          child: Row(
                                            children: [
                                              IconButton.filled(
                                                tooltip: 'Play audio',
                                                onPressed: () =>
                                                    _toggleAudio(index),
                                                icon:
                                                    (hasAudioPlayers
                                                        ? !_isPlaying[index]
                                                        : true)
                                                    ? Icon(
                                                        Icons
                                                            .volume_up_outlined,
                                                        size: 20,
                                                      )
                                                    : Lottie.asset(
                                                        'assets/sound_voice_waves.json',
                                                        width: 20,
                                                        height: 20,
                                                        repeat: true,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              IconButton.outlined(
                                                tooltip: 'Translate',
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.translate_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                              if (turn?.context_note != null)
                                                IconButton.outlined(
                                                  tooltip: 'Context note',
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all(
                                                          _showContextNote
                                                                  .contains(
                                                                    index,
                                                                  )
                                                              ? AppColors
                                                                    .primaryContainer
                                                              : AppColors.white,
                                                        ),
                                                  ),
                                                  onPressed: () => setState(() {
                                                    _showContextNote.contains(
                                                          index,
                                                        )
                                                        ? _showContextNote
                                                              .remove(index)
                                                        : _showContextNote.add(
                                                            index,
                                                          );
                                                  }),
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 20,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_showContextNote.contains(index) &&
                                        turn?.context_note != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        turn!.context_note!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
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
                  },
            ),
          ),
        );
      },
    );
  }
}
