import 'package:flutter/material.dart';
import 'package:zingo/constants/notification_time.dart';
import 'package:zingo/widgets/card_select.dart';
import 'package:zingo/widgets/pickers/time_picker.dart';

class ReminderTime extends StatelessWidget {
  const ReminderTime({
    super.key,
    required this.notificationTime,
    required this.onChange,
  });
  final TimeOfDay notificationTime;
  final ValueChanged<TimeOfDay> onChange;

  void _onChange(TimeOfDay time) {
    onChange(time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminder time',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              "We'll nudge you so you never break your streak.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.4,
          crossAxisCount: 2,
          children: NotificationTime.all.map((nt) {
            return CardSelect(
              emoji: nt.emoji,
              label: nt.label,
              isSelected: notificationTime == nt.value,
              onTap: () => _onChange(nt.value),
              labelStyle: Theme.of(context).textTheme.bodySmall,
              labelMaxLines: 2,
              checkIconSize: 16,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Text(
          'Or pick a custom time',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        TimePicker(
          value: notificationTime,
          onConfirm: (time) => _onChange(time ?? notificationTime),
        ),
      ],
    );
  }
}
