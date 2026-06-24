import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';

class TimePicker extends StatelessWidget {
  final TimeOfDay? value;
  final Function(TimeOfDay?) onConfirm;
  final String? placeholder;
  final Widget Function(Future<void> Function() onConfirm)? trigger;

  const TimePicker({
    super.key,
    this.value,
    required this.onConfirm,
    this.placeholder = "Pick a time",
    this.trigger,
  });

  Future<void> _showTimePickerDialog(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
    );
    if (time != null) {
      onConfirm(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (trigger != null) {
      return trigger!(() => _showTimePickerDialog(context));
    }
    return InkWell(
      onTap: () => _showTimePickerDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.access_alarm_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value?.format(context) ?? placeholder ?? 'Pick a time',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: value == null ? AppColors.textSecondary : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
