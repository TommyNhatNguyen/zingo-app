import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/card_select_icon.dart';
import 'package:zingo/ui/explore-detail/widgets/practice_mode_preview.dart';

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
  void _showDifferenceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.8,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.whatsTheDifference,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(dialogContext),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 16,
                        children: PracticeMode.values.map((mode) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Row(
                                spacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      mode.icon,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    mode.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              PracticeModePreview(selectedMode: mode),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("Got it"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
              context.l10n.practiceMode,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () => _showDifferenceDialog(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(context.l10n.whatsTheDifference),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: PracticeMode.values.map((mode) {
            final isDisabled = mode == PracticeMode.freeSpeak;
            return Expanded(
              child: CardSelectIcon(
                icon: mode.icon,
                label: mode.label,
                description: mode.description,
                isSelected: widget.selectedMode == mode,
                isDisabled: isDisabled,
                onTap: () {
                  if (isDisabled) {
                    Toastification().show(
                      context: context,
                      type: ToastificationType.info,
                      style: ToastificationStyle.flat,
                      alignment: AlignmentGeometry.bottomCenter,
                      title: Text(context.l10n.info),
                      description: Text(context.l10n.modeNotAvailable),
                      autoCloseDuration: const Duration(seconds: 4),
                    );
                    return;
                  }
                  widget.onModeSelected(mode);
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
