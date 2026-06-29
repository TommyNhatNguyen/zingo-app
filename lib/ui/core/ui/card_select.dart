import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';

class CardSelect extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final TextStyle? emojiStyle;
  final TextStyle? labelStyle;
  final int? labelMaxLines;
  final double? checkIconSize;

  const CardSelect({
    super.key,
    required this.emoji,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.emojiStyle,
    this.labelStyle,
    this.labelMaxLines,
    this.checkIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: isSelected ? AppColors.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.textDisabled,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                if (isSelected)
                  Icon(Icons.check_circle, color: AppColors.primary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
