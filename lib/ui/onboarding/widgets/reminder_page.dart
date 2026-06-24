import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/core/constants/notification_time.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/ui/onboarding/widgets/profile_page.dart';
import 'package:zingo/ui/core/ui/card_select.dart';
import 'package:zingo/ui/core/ui/pickers/time_picker.dart';

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
    final l10n = context.l10n;
    return ProfilePage(
      emoji: '🔔',
      title: l10n.reminderTimeTitle,
      description: l10n.reminderTimeSubtitle,
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
                          l10n.dailyReminders,
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
                  Text(l10n.orPickCustomTime),
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
