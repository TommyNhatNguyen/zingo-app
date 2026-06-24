import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/domain/models/dialog.dart' as dialog_model;
import 'package:zingo/utils/capitalize_util.dart';

class DialogDetailTitle extends StatelessWidget {
  const DialogDetailTitle({super.key, required this.dialog});

  final dialog_model.Dialog? dialog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      spacing: 4,
      children: [
        Text(
          CapitalizeUtil.capitalize(text: dialog?.title ?? ''),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          dialog?.description ?? '',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        Transform.translate(
          offset: const Offset(-3, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Chip(label: Text(dialog?.level ?? '')),
              Chip(label: Text(dialog?.duration ?? '')),
              Chip(
                label: Text(
                  "${dialog?.conversation_length.toString()} turns",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
