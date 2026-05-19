import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';

Map<int, String> weekdays = {
  1: "M",
  2: "T",
  3: "W",
  4: "T",
  5: "F",
  6: "S",
  7: "S",
};

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<DateTime> days = List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actionsPadding: const EdgeInsets.only(right: 16),
        title: Text(
          "Pick a dialog",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          Chip(
            avatar: Icon(Icons.star_border, color: AppColors.xp),
            label: Text(
              '10',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.xp,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.highlightContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              StreakCard(days: days),
              const SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.play_arrow),
                          const SizedBox(width: 8),
                          Text("Continue practicing"),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text("2 in progress"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) => TopicCard(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(" tapped");
      },
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.accentContainer,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.cast_for_education),
                    ),
                    Align(
                      alignment: Alignment(0.88, -0.84),
                      child: FittedBox(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.star_border,
                                color: AppColors.textOnHighlight,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "78",
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.88, 0.84),
                      child: FittedBox(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "2 min",
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Cafe"),
                  Text("Ordering coffee at a busy cafe", softWrap: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.days});

  final List<DateTime> days;

  @override
  Widget build(BuildContext context) {
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
                              weekdays[day.weekday] ?? "",
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
