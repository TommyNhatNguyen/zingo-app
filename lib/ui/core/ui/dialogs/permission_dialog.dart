import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/themes/app_text_styles.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

  /// Shows the microphone permission dialog.
  /// Returns `true` when the user chose to open app settings.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const PermissionDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.accentContainer,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mic_off_rounded,
          color: AppColors.accent,
          size: 28,
        ),
      ),
      title: Text(
        'Microphone access needed',
        textAlign: TextAlign.center,
        style: AppTextStyles.h2,
      ),
      content: Text(
        'Lingo Snack needs microphone and speech access so you can practice '
        'speaking. Please enable it in Settings to continue.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.white,
          ),
          child: const Text('Open Settings'),
        ),
      ],
    );
  }
}
