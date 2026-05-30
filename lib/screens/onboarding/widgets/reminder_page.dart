import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/notification_time.dart';
import 'package:zingo/screens/onboarding/widgets/profile_page.dart';
import 'package:zingo/widgets/card_select.dart';
import 'package:zingo/widgets/pickers/time_picker.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({
    super.key,
    required this.isDailyRemindersEnabled,
    required this.selectedTime,
    required this.onToggleReminders,
    required this.onSelectTime,
  });

  final bool isDailyRemindersEnabled;
  final TimeOfDay? selectedTime;
  final VoidCallback onToggleReminders;
  final ValueChanged<TimeOfDay> onSelectTime;

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      emoji: '🔔',
      title: 'Reminder time',
      description: "We'll nudge you so you never break your streak",
      child: Expanded(
        child: Column(
          children: [
            InkWell(
              onTap: onToggleReminders,
              child: Card.outlined(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.divider),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Daily reminders',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Switch(
                        value: isDailyRemindersEnabled,
                        onChanged: (_) => onToggleReminders(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 2,
                crossAxisCount: 2,
                children: NotificationTime.all
                    .map(
                      (time) => CardSelect(
                        emoji: time.emoji,
                        label: time.label,
                        isSelected: selectedTime == time.value,
                        onTap: () => onSelectTime(time.value),
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        labelMaxLines: 2,
                        checkIconSize: 16,
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Or pick a custom time'),
                  const SizedBox(height: 8),
                  TimePicker(
                    value: selectedTime ?? TimeOfDay.now(),
                    onConfirm: (time) => onSelectTime(time ?? TimeOfDay.now()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
