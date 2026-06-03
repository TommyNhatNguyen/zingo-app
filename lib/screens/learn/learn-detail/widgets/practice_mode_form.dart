import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';

class PracticeModeForm extends StatefulWidget {
  const PracticeModeForm({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  final PracticeMode selectedMode;
  final ValueChanged<PracticeMode> onModeSelected;

  @override
  State<PracticeModeForm> createState() => _PracticeModeFormState();
}

class _PracticeModeFormState extends State<PracticeModeForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PRACTICE MODE",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text("What's the difference?"),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: PracticeMode.values.map((mode) {
            final isSelected = widget.selectedMode == mode;
            return Expanded(
              child: Card.outlined(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    if (mode == PracticeMode.freeSpeak) {
                      Toastification().show(
                        context: context,
                        type: ToastificationType.info,
                        style: ToastificationStyle.flat,
                        alignment: AlignmentGeometry.bottomCenter,
                        title: const Text('Info'),
                        description: const Text(
                          'This mode is not available yet',
                        ),
                        autoCloseDuration: const Duration(seconds: 4),
                      );
                      return;
                    }
                    widget.onModeSelected(mode);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primaryContainer.withAlpha(100),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                mode.icon,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              mode.label,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              mode.description,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
