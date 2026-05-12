import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';

class TimePicker extends StatelessWidget {
  final TimeOfDay? value;
  final Function(TimeOfDay?) onConfirm;
  final String? placeholder;

  const TimePicker({
    super.key,
    this.value,
    required this.onConfirm,
    this.placeholder = "Pick a time",
  });

  Future<void> _showTimePickerDialog(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      onConfirm(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showTimePickerDialog(context),
      icon: Icon(Icons.access_time),
      iconAlignment: IconAlignment.end,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      label: SizedBox(
        width: double.infinity,
        child: Text(
          value?.format(context) ?? placeholder ?? "Pick a time",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
