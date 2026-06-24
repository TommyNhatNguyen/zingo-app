import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/domain/models/dialog.dart' as dialog_model;

class DialogDetailScoring extends StatelessWidget {
  const DialogDetailScoring({super.key, this.dialog});

  final dialog_model.Dialog? dialog;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        spacing: 16,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LAST",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      "${dialog?.progress?.latest_score?.toStringAsFixed(0) ?? 0}",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BEST",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      "${dialog?.progress?.highest_score?.toStringAsFixed(0) ?? 0}",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: AppColors.highlight,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Chip(
            backgroundColor: AppColors.primaryContainer,
            avatar: Icon(Icons.repeat_rounded),
            label: Text(
              "${dialog?.progress?.attempts ?? 0} tries",
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
