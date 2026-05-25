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

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    this.practiceSessionId = '1c11f53a-d653-4e1d-97e2-242e82ebe22b',
    this.dialogId = '13febbdf-a74c-4904-bc3b-c22bdec6a327',
  });
  final String practiceSessionId;
  final String dialogId;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  DialogTurnsListByDialogBloc get bloc =>
      context.read<DialogTurnsListByDialogBloc>();
  final _chatController = InMemoryChatController();
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
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

  void _toggleAudio() async {
    if (_isPlaying) {
      // await _audioPlayer.pause();
      return;
    } else {
      setState(() {
        _isPlaying = !_isPlaying;
      });
      await _audioPlayer.play();
      await _audioPlayer.pause();
      await _audioPlayer.seek(Duration.zero);
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    _audioPlayer.dispose();
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
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.success) {
          if (state.data != null) {
            _chatController.insertAllMessages(
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
            _audioPlayer.setUrl(state.data!.first.tts_model_audio_url ?? '');
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

            // onMessageSend: (message) {
            //   _chatController.insertMessage(
            //     TextMessage(
            //       id: UniqueKey().toString(),
            //       authorId: 'user1',
            //       text: message,
            //     ),
            //   );
            // },
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
                    print(turn);
                    if (turn?.speaker == Speaker.ai) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                widthFactor: 0.9,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(turn?.line_text ?? ''),
                                    ),
                                    const SizedBox(height: 4),
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
                                                onPressed: () => _toggleAudio(),
                                                icon: !_isPlaying
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
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [child],
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
