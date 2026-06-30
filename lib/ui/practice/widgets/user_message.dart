import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/core/blocs/locale/locale_cubit.dart';
import 'package:zingo/domain/models/dialog_turn.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/utils/matching_text_service.dart';
import 'package:zingo/utils/translation_service.dart';

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
  String? _translatedText;
  bool _isTranslating = false;

  Future<void> _toggleTranslation() async {
    if (_translatedText != null) {
      setState(() => _translatedText = null);
      return;
    }

    final text = widget.turn?.line_text;
    if (text == null || text.isEmpty) return;

    final localeCode = context.read<LocaleCubit>().state.languageCode;
    if (localeCode == 'en') return;

    setState(() => _isTranslating = true);

    final result = await TranslationService.instance.translate(
      text,
      localeCode,
    );

    if (!mounted) return;
    setState(() {
      _translatedText = result;
      _isTranslating = false;
    });
  }

  List<InlineSpan> _buildTokenSpans(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyLarge;
    final underlined = base?.copyWith(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dashed,
    );

    if (widget.tokens != null) {
      return widget.tokens!
          .expand(
            (token) => [
              TextSpan(
                text: token.display,
                style: token.state == WordState.matched
                    ? underlined?.copyWith(color: AppColors.scoreHigh)
                    : underlined,
              ),
              const TextSpan(text: '  '),
            ],
          )
          .toList();
    }

    return (widget.turn?.line_text.split(' ') ?? [])
        .expand(
          (word) => [
            TextSpan(text: word, style: underlined),
            const TextSpan(text: '  '),
          ],
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isTranslated = _translatedText != null;

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
                    if (isTranslated) ...[
                      const Divider(height: 12),
                      Text(
                        _translatedText!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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
                            tooltip: isTranslated
                                ? 'Hide translation'
                                : 'Translate',
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                isTranslated
                                    ? AppColors.primaryContainer
                                    : AppColors.white,
                              ),
                            ),
                            onPressed: _isTranslating ? null : _toggleTranslation,
                            icon: _isTranslating
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.translate_outlined,
                                    size: 20,
                                    color: isTranslated
                                        ? AppColors.primary
                                        : null,
                                  ),
                          ),
                        ],
                      ),
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
  }
}
