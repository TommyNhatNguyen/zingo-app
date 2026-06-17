import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';

const Map<int, String> _weekdays = {
  1: "M",
  2: "T",
  3: "W",
  4: "T",
  5: "F",
  6: "S",
  7: "S",
};

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  List<DateTime> _buildWeekDays() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildWeekDays();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Icon(Icons.fireplace),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Daily streak'), Text("7 Days")],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Text("Best"), Text("14 days")],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weekdays[day.weekday] ?? "",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.fire_extinguisher_outlined),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.ads_click_outlined, size: 18),
                  const SizedBox(width: 8),
                  const Text("Practice today - keep the fire alive!"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
