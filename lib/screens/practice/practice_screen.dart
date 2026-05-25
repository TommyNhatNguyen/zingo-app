import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_event.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/models/dialog_turn.dart';
import 'package:zingo/screens/learn/learn-detail/learn_detail_screen.dart';
import 'package:zingo/services/cache_service.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    this.practiceSessionId = '1c11f53a-d653-4e1d-97e2-242e82ebe22b',
    this.dialogId = '13febbdf-a74c-4904-bc3b-c22bdec6a327',
    this.praceticeMode = PracticeMode.readAloud,
  });
  final String practiceSessionId;
  final String dialogId;
  final PracticeMode praceticeMode;
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  DialogTurnsListByDialogBloc get bloc =>
      context.read<DialogTurnsListByDialogBloc>();
  final _chatController = InMemoryChatController();
  final List<AudioPlayer> _audioPlayers = [];
  final List<bool> _isPlaying = [];
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
    print(widget.practiceSessionId);
    print(widget.dialogId);
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
          appBar: AppBar(title: Text('Practice')),
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                                    Text(
                                      "Context: ${turn?.context_note ?? 'no context'}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
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
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.translate_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
