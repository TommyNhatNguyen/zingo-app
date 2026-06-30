import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';

class FilterPickerChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final int selectedCount;
  final VoidCallback onTap;

  const FilterPickerChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isActive = selectedCount > 0;

    return Material(
      color: isActive ? AppColors.primaryContainer : AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(
          color: isActive ? AppColors.primary : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? AppColors.primaryDark : AppColors.textSecondary,
              ),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: isActive ? AppColors.primaryDark : AppColors.textSecondary,
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '$selectedCount',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: isActive ? AppColors.primaryDark : AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
