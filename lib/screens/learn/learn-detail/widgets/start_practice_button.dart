import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;

class StartPracticeButton extends StatelessWidget {
  const StartPracticeButton({
    super.key,
    required this.dialogId,
    required this.selectedMode,
    this.dialog,
  });

  final String dialogId;
  final PracticeMode selectedMode;
  final dialog_model.Dialog? dialog;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              context.pushReplacement(
                '/practice',
                extra: {
                  'practice_session_id': dialog?.practice_session_id ?? '',
                  'dialog_id': dialogId,
                  'pracetice_mode': selectedMode,
                  'dialog': dialog,
                },
              );
            },
            icon: const Icon(Icons.mic_outlined),
            label: const Text("Start practice"),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.white,
              elevation: 4,
              shadowColor: AppColors.accentLight.withAlpha(150),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall,
            children: [
              TextSpan(text: "${selectedMode.label} · "),
              TextSpan(
                text: '+${dialog?.xp_points ?? 0} XP',
                style: const TextStyle(
                  color: AppColors.xp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
