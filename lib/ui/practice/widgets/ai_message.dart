import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/domain/models/dialog_turn.dart';

class AiMessage extends StatefulWidget {
  const AiMessage({
    super.key,
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
  State<AiMessage> createState() => _AiMessageState();
}

class _AiMessageState extends State<AiMessage> {
  bool _showContextNote = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
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
                                : const Icon(Icons.volume_up_outlined, size: 20),
                          ),
                          IconButton.outlined(
                            tooltip: 'Translate',
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(AppColors.white),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.translate_outlined, size: 20),
                          ),
                          if (widget.turn?.context_note != null)
                            IconButton.outlined(
                              tooltip: 'Context note',
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  _showContextNote
                                      ? AppColors.primaryContainer
                                      : AppColors.white,
                                ),
                              ),
                              onPressed: () =>
                                  setState(() => _showContextNote = !_showContextNote),
                              icon: const Icon(Icons.info_outline, size: 20),
                            ),
                        ],
                      ),
                    ),
                    if (_showContextNote && widget.turn?.context_note != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.turn!.context_note!,
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
