import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/themes/app_text_styles.dart';
import 'package:zingo/ui/home/widgets/dashed_line_painter.dart';
import 'package:zingo/ui/home/widgets/home_lesson.dart';

class HomeChapterDivider extends StatelessWidget {
  const HomeChapterDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Row(
        children: [
          const SizedBox(width: 34),
          Expanded(child: Container(height: 1, color: AppColors.border)),
        ],
      ),
    );
  }
}

class HomeEmptyJourney extends StatelessWidget {
  const HomeEmptyJourney({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            context.l10n.noJourneyYet,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.noJourneySubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class HomeJourneyComplete extends StatelessWidget {
  const HomeJourneyComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Center(
        child: Text(
          context.l10n.journeyComplete,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}

class HomeLessonRow extends StatelessWidget {
  const HomeLessonRow({super.key, required this.lesson});

  final HomeLesson lesson;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 68,
          child: Center(child: HomeLessonNode(lesson: lesson)),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: lesson.state == HomeLessonState.nextUp ? 0 : 4,
            ),
            child: HomeLessonContent(lesson: lesson),
          ),
        ),
      ],
    );
  }
}

class HomeLessonConnector extends StatelessWidget {
  const HomeLessonConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          SizedBox(
            width: 68,
            child: Center(
              child: CustomPaint(
                size: const Size(2, 20),
                painter: DashedLinePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeLessonNode extends StatelessWidget {
  const HomeLessonNode({super.key, required this.lesson});

  final HomeLesson lesson;

  @override
  Widget build(BuildContext context) {
    switch (lesson.state) {
      case HomeLessonState.completed:
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.scoreHigh,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 24),
        );

      case HomeLessonState.nextUp:
        return GestureDetector(
          onTap: () => context.push(
            '/learn/${lesson.id}',
            extra: {'suggestion_dialog_id': lesson.slotId},
          ),
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'START',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    height: 1.2,
                  ),
                ),
                Text(
                  'HERE',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        );

      case HomeLessonState.locked:
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.border.withValues(alpha: 0.6),
          ),
          child: const Icon(
            Icons.lock_rounded,
            color: AppColors.textDisabled,
            size: 20,
          ),
        );
    }
  }
}

class HomeLessonContent extends StatelessWidget {
  const HomeLessonContent({super.key, required this.lesson});

  final HomeLesson lesson;

  @override
  Widget build(BuildContext context) {
    switch (lesson.state) {
      case HomeLessonState.completed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.lessonLabel(lesson.number),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              lesson.title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case HomeLessonState.nextUp:
        return GestureDetector(
          onTap: () => context.push(
            '/learn/${lesson.id}',
            extra: {'suggestion_dialog_id': lesson.slotId},
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      context.l10n.lessonNextUpLabel(lesson.number),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star_border_rounded,
                      color: AppColors.xp,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+${lesson.xpGain}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.xp,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  lesson.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (lesson.level != null) HomeLessonInfoChip(lesson.level!),
                    if (lesson.turns != null) ...[
                      const SizedBox(width: 6),
                      HomeLessonInfoChip('${lesson.turns} turns'),
                    ],
                    if (lesson.durationMin != null) ...[
                      const SizedBox(width: 6),
                      HomeLessonInfoChip('${lesson.durationMin} min'),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );

      case HomeLessonState.locked:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.lessonLabel(lesson.number),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textDisabled,
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              lesson.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ],
        );
    }
  }
}

class HomeLessonInfoChip extends StatelessWidget {
  const HomeLessonInfoChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }
}
