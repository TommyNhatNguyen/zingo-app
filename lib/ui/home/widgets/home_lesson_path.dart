import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/models/journey.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/themes/app_text_styles.dart';
import 'package:zingo/ui/home/widgets/home_lesson.dart';
import 'package:zingo/ui/home/widgets/home_lesson_widgets.dart';

class HomeLessonPath extends StatelessWidget {
  const HomeLessonPath({super.key});

  static int _durationMin(String duration) {
    switch (duration) {
      case 'short':
        return 2;
      case 'mid':
        return 5;
      case 'long':
        return 10;
      default:
        return 3;
    }
  }

  static List<HomeLesson> _buildLessons(
    JourneyChapter chapter, {
    required bool isCurrentChapter,
    required bool isFuture,
  }) {
    int? nextUpIndex;
    if (isCurrentChapter) {
      final inProgressIdx = chapter.dialogs.indexWhere((s) => s.isInProgress);
      if (inProgressIdx != -1) {
        nextUpIndex = inProgressIdx;
      } else {
        nextUpIndex = chapter.dialogs.indexWhere((s) => !s.isCompleted);
      }
    }

    return chapter.dialogs.asMap().entries.map((entry) {
      final i = entry.key;
      final slot = entry.value;
      final dialog = slot.dialog;

      if (isFuture || (!slot.isCompleted && i != nextUpIndex)) {
        return HomeLesson(
          id: dialog.id,
          slotId: slot.slot_id,
          number: i + 1,
          title: dialog.title,
          state: HomeLessonState.locked,
          level: dialog.cefr_level,
          turns: dialog.conversation_length,
          durationMin: _durationMin(dialog.duration),
          xpGain: dialog.xp_points,
        );
      }

      if (slot.isCompleted) {
        return HomeLesson(
          id: dialog.id,
          slotId: slot.slot_id,
          number: i + 1,
          title: dialog.title,
          state: HomeLessonState.completed,
          level: dialog.cefr_level,
          turns: dialog.conversation_length,
          durationMin: _durationMin(dialog.duration),
          xpGain: dialog.xp_points,
        );
      }

      return HomeLesson(
        id: dialog.id,
        slotId: slot.slot_id,
        number: i + 1,
        title: dialog.title,
        state: HomeLessonState.nextUp,
        level: dialog.cefr_level,
        turns: dialog.conversation_length,
        durationMin: _durationMin(dialog.duration),
        xpGain: dialog.xp_points,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JourneyBloc, JourneyState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading ||
            state.requestStatus == RequestStatus.initial) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.chapters.isEmpty) {
          return const HomeEmptyJourney();
        }

        final currentChapter = state.currentChapter;
        final currentIndex = currentChapter != null
            ? state.chapters.indexOf(currentChapter)
            : state.chapters.length - 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int ci = 0; ci < state.chapters.length; ci++) ...[
              if (ci > 0) const HomeChapterDivider(),
              _ChapterSection(
                chapter: state.chapters[ci],
                chapterNum: ci + 1,
                isCurrentChapter: ci == currentIndex,
                isFuture: ci > currentIndex,
              ),
            ],
            if (state.requestStatus == RequestStatus.loadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!state.hasMore && state.chapters.isNotEmpty)
              const HomeJourneyComplete(),
          ],
        );
      },
    );
  }
}

class _ChapterSection extends StatelessWidget {
  const _ChapterSection({
    required this.chapter,
    required this.chapterNum,
    required this.isCurrentChapter,
    required this.isFuture,
  });

  final JourneyChapter chapter;
  final int chapterNum;
  final bool isCurrentChapter;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lessons = HomeLessonPath._buildLessons(
      chapter,
      isCurrentChapter: isCurrentChapter,
      isFuture: isFuture,
    );
    final completedCount = lessons
        .where((l) => l.state == HomeLessonState.completed)
        .length;
    final topicName = chapter.dialogs.isNotEmpty
        ? (chapter.dialogs.first.dialog.topics?.name ??
                  chapter.dialogs.first.dialog.topic_id)
              .toUpperCase()
        : 'YOUR PATH';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chapterLabel(chapterNum, topicName),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isFuture
                        ? AppColors.textDisabled
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 196,
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: isFuture ? AppColors.border : AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              l10n.completedOfTotal(completedCount, lessons.length),
              style: AppTextStyles.labelMedium.copyWith(
                color: isFuture
                    ? AppColors.textDisabled
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        for (int i = 0; i < lessons.length; i++) ...[
          HomeLessonRow(lesson: lessons[i]),
          if (i < lessons.length - 1) const HomeLessonConnector(),
        ],
      ],
    );
  }
}
