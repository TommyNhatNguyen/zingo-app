import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';

class YoullBeScoredOn extends StatelessWidget {
  const YoullBeScoredOn({super.key, required this.selectedMode});

  final PracticeMode selectedMode;

  static const _dimensions = [
    (
      showMode: [PracticeMode.freeSpeak],
      icon: Icons.translate,
      color: Color(0xFF0891B2),
      containerColor: Color(0xFFE0F7FB),
      title: "Grammar",
      tag: "Structure",
      description: "Correct tense, agreement, word order, prepositions.",
      example: "e.g. \"Try 'could I have' — more polite here.\"",
    ),
    (
      showMode: [PracticeMode.freeSpeak],
      icon: Icons.auto_fix_high,
      color: Color(0xFFDB2777),
      containerColor: Color(0xFFFCE7F3),
      title: "Naturalness",
      tag: "Native-like",
      description: "How fluent and idiomatic your phrasing sounds.",
      example: "e.g. \"Skip 'please' mid-sentence — feels more casual.\"",
    ),
    (
      showMode: [PracticeMode.freeSpeak, PracticeMode.readAloud],
      icon: Icons.check,
      color: Color(0xFF22C55E),
      containerColor: Color(0xFFDCFCE7),
      title: "Completeness",
      tag: "Coverage",
      description: "Whether you addressed everything the AI asked.",
      example: "e.g. \"Answered both questions clearly — great.\"",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "YOU'LL BE SCORED ON",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: _dimensions.indexed.expand<Widget>((entry) {
              final (i, dim) = entry;
              if (!dim.showMode.contains(selectedMode)) return const [];
              return [
                if (i > 0) Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: dim.containerColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(dim.icon, color: dim.color, size: 20),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dim.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      dim.tag,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: dim.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Text(
                                  dim.description,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: dim.containerColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dim.example,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: dim.color,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            }).toList(),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Score ranges: ",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.xp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...[
                (color: AppColors.scoreLow, label: "0–50"),
                (color: AppColors.scoreMid, label: "51–74"),
                (color: AppColors.primary, label: "75–89"),
                (color: AppColors.scoreHigh, label: "90–100"),
              ].map(
                (range) => Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: range.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      range.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
