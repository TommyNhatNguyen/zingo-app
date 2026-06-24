import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';

class YoullBeScoredOn extends StatelessWidget {
  const YoullBeScoredOn({super.key, required this.selectedMode});

  final PracticeMode selectedMode;

  static const _dimensionMeta = [
    (
      showMode: [PracticeMode.freeSpeak],
      icon: Icons.translate,
      color: Color(0xFF0891B2),
      containerColor: Color(0xFFE0F7FB),
    ),
    (
      showMode: [PracticeMode.freeSpeak],
      icon: Icons.auto_fix_high,
      color: Color(0xFFDB2777),
      containerColor: Color(0xFFFCE7F3),
    ),
    (
      showMode: [PracticeMode.freeSpeak, PracticeMode.readAloud],
      icon: Icons.check,
      color: Color(0xFF22C55E),
      containerColor: Color(0xFFDCFCE7),
    ),
  ];

  List<
    ({
      List<PracticeMode> showMode,
      IconData icon,
      Color color,
      Color containerColor,
      String title,
      String tag,
      String description,
      String example,
    })
  >
  _buildDimensions(AppLocalizations l10n) {
    return [
      (
        showMode: _dimensionMeta[0].showMode,
        icon: _dimensionMeta[0].icon,
        color: _dimensionMeta[0].color,
        containerColor: _dimensionMeta[0].containerColor,
        title: l10n.scoreDimGrammar,
        tag: l10n.scoreDimGrammarTag,
        description: l10n.scoreDimGrammarDesc,
        example: l10n.scoreDimGrammarExample,
      ),
      (
        showMode: _dimensionMeta[1].showMode,
        icon: _dimensionMeta[1].icon,
        color: _dimensionMeta[1].color,
        containerColor: _dimensionMeta[1].containerColor,
        title: l10n.scoreDimNaturalness,
        tag: l10n.scoreDimNaturalnessTag,
        description: l10n.scoreDimNaturalnessDesc,
        example: l10n.scoreDimNaturalnessExample,
      ),
      (
        showMode: _dimensionMeta[2].showMode,
        icon: _dimensionMeta[2].icon,
        color: _dimensionMeta[2].color,
        containerColor: _dimensionMeta[2].containerColor,
        title: l10n.scoreDimCompleteness,
        tag: l10n.scoreDimCompletenessTag,
        description: l10n.scoreDimCompletenessDesc,
        example: l10n.scoreDimCompletenessExample,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = _buildDimensions(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.youllBeScoredOn,
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
            children: dimensions.indexed.expand<Widget>((entry) {
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
                l10n.scoreRanges,
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
