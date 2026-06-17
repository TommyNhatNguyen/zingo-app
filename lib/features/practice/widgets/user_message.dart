import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/models/dialog_turn.dart';
import 'package:zingo/services/matching_text_service.dart';

class UserMessage extends StatefulWidget {
  const UserMessage({
    super.key,
    required this.turn,
    required this.index,
    required this.isPlaying,
    required this.onPlay,
    this.tokens,
  });

  final DialogTurn? turn;
  final int index;
  final bool isPlaying;
  final VoidCallback onPlay;
  final List<TokenResult>? tokens;

  @override
  State<UserMessage> createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
  bool _showContextNote = false;

  List<InlineSpan> _buildTokenSpans(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyLarge;
    final underlined = base?.copyWith(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dashed,
    );

    if (widget.tokens != null) {
      return widget.tokens!
          .expand((token) => [
                TextSpan(
                  text: token.display,
                  style: token.state == WordState.matched
                      ? underlined?.copyWith(color: AppColors.scoreHigh)
                      : underlined,
                ),
                const TextSpan(text: '  '),
              ])
          .toList();
    }

    return (widget.turn?.line_text.split(' ') ?? [])
        .expand((word) => [
              TextSpan(text: word, style: underlined),
              const TextSpan(text: '  '),
            ])
        .toList();
  }

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
                        children: _buildTokenSpans(context),
                      ),
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
                      const SizedBox(height: 4),
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
