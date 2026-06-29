import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';

class CardInfo extends StatelessWidget {
  final String emoji;
  final String label;
  final TextStyle? emojiStyle;
  final TextStyle? labelStyle;
  final int? labelMaxLines;

  const CardInfo({
    super.key,
    required this.emoji,
    required this.label,
    this.emojiStyle,
    this.labelStyle,
    this.labelMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: Row(
            children: [
              Text(
                emoji,
                style: emojiStyle ?? Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
                  maxLines: labelMaxLines,
                  overflow: labelMaxLines != null
                      ? TextOverflow.ellipsis
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
