import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/blocs/journey/journey_bloc.dart';
import 'package:zingo/blocs/journey/journey_event.dart';
import 'package:zingo/blocs/journey/journey_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/config/app_text_styles.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/journey/journey_payload.dart';
import 'package:zingo/models/journey.dart';
import 'package:zingo/models/users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;

    // Layout-phase notifications always fire at pixels == 0.
    // Require actual downward scroll before evaluating.
    if (pos.maxScrollExtent <= 0) return;
    if (pos.pixels <= 0) return;
    if (pos.pixels < pos.maxScrollExtent - 300) return;

    final state = context.read<JourneyBloc>().state;
    if (!state.hasMore) return;
    if (state.requestStatus == RequestStatus.loading ||
        state.requestStatus == RequestStatus.loadingMore) return;

    context.read<JourneyBloc>().add(
      JourneyFetchMoreEvent(
        payload: JourneyPayload(page: (state.meta?.page ?? 1) + 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.data;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GreetingRow(user: user),
                  const SizedBox(height: 14),
                  _StreakCard(user: user),
                  const SizedBox(height: 28),
                  _LessonPath(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Greeting Row ─────────────────────────────────────────────────────────────

class _GreetingRow extends StatelessWidget {
  final Users? user;

  const _GreetingRow({required this.user});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting(), style: AppTextStyles.bodySmall),
            Text(user?.username ?? '—', style: AppTextStyles.h2),
          ],
        ),
        const Spacer(),
        Chip(
          label: Text(
            '${user?.xp ?? 0}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textOnAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: AppColors.xp,
          avatar: const Icon(
            Icons.star_rounded,
            color: AppColors.textOnAccent,
            size: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

// ─── Streak Card ──────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final Users? user;

  const _StreakCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final streakDays = user?.streak ?? 0;
    final bestStreak = user?.longest_streak ?? 0;
    final todayIndex = DateTime.now().weekday - 1;
    final weekStreak = user?.currentWeekStreak ?? {};

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.streak,
                size: 30,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily streak', style: AppTextStyles.bodySmall),
                  Text(
                    '$streakDays ${streakDays == 1 ? 'day' : 'days'}',
                    style: AppTextStyles.h2,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'BEST',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textDisabled,
                      fontSize: 10,
                    ),
                  ),
                  Text('${bestStreak}d', style: AppTextStyles.h2),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 7; i++)
                _DayCell(
                  label: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
                  state: weekStreak[i.toString()] == true
                      ? _DayCellState.completed
                      : i == todayIndex
                      ? _DayCellState.today
                      : _DayCellState.inactive,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _DayCellState { completed, today, inactive }

class _DayCell extends StatelessWidget {
  final String label;
  final _DayCellState state;

  const _DayCell({required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 11,
            color: state == _DayCellState.inactive
                ? AppColors.textDisabled
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        _buildIcon(),
      ],
    );
  }

  Widget _buildIcon() {
    switch (state) {
      case _DayCellState.completed:
        return Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentContainer,
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.streak,
            size: 19,
          ),
        );
      case _DayCellState.today:
        return Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.primary,
            size: 19,
          ),
        );
      case _DayCellState.inactive:
        return Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.border.withValues(alpha: 0.5),
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.textDisabled,
            size: 19,
          ),
        );
    }
  }
}

// ─── Lesson Path ──────────────────────────────────────────────────────────────

enum _LessonState { completed, nextUp, locked }

class _Lesson {
  final String id;
  final int number;
  final String title;
  final _LessonState state;
  final String? level;
  final int? turns;
  final int? durationMin;
  final int? xpGain;

  const _Lesson({
    required this.id,
    required this.number,
    required this.title,
    required this.state,
    this.level,
    this.turns,
    this.durationMin,
    this.xpGain,
  });
}

class _LessonPath extends StatelessWidget {
  _LessonPath();

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

  List<_Lesson> _buildLessons(
    JourneyChapter chapter, {
    required bool isCurrentChapter,
    required bool isFuture,
  }) {
    // Find the first non-completed slot in the current chapter — that's "next up".
    // in_progress takes priority over the first waiting slot.
    int? nextUpIndex;
    if (isCurrentChapter) {
      // Prefer an in_progress slot; fall back to first waiting.
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
        return _Lesson(
          id: dialog.id,
          number: i + 1,
          title: dialog.title,
          state: _LessonState.locked,
          level: dialog.cefr_level,
          turns: dialog.conversation_length,
          durationMin: _durationMin(dialog.duration),
          xpGain: dialog.xp_points,
        );
      }

      if (slot.isCompleted) {
        return _Lesson(
          id: dialog.id,
          number: i + 1,
          title: dialog.title,
          state: _LessonState.completed,
          level: dialog.cefr_level,
          turns: dialog.conversation_length,
          durationMin: _durationMin(dialog.duration),
          xpGain: dialog.xp_points,
        );
      }

      // i == nextUpIndex
      return _Lesson(
        id: dialog.id,
        number: i + 1,
        title: dialog.title,
        state: _LessonState.nextUp,
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
          return _EmptyJourney();
        }

        final currentChapter = state.currentChapter;
        final currentIndex = currentChapter != null
            ? state.chapters.indexOf(currentChapter)
            : state.chapters.length - 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int ci = 0; ci < state.chapters.length; ci++) ...[
              if (ci > 0) const _ChapterDivider(),
              _buildChapterSection(
                state.chapters[ci],
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
              const _JourneyComplete(),
          ],
        );
      },
    );
  }

  Widget _buildChapterSection(
    JourneyChapter chapter, {
    required int chapterNum,
    required bool isCurrentChapter,
    required bool isFuture,
  }) {
    final lessons = _buildLessons(
      chapter,
      isCurrentChapter: isCurrentChapter,
      isFuture: isFuture,
    );
    final completedCount = lessons
        .where((l) => l.state == _LessonState.completed)
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
                  'CHAPTER $chapterNum · $topicName',
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
              '$completedCount of ${lessons.length}',
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
          _LessonRow(lesson: lessons[i]),
          if (i < lessons.length - 1) const _LessonConnector(),
        ],
      ],
    );
  }
}

class _ChapterDivider extends StatelessWidget {
  const _ChapterDivider();

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

class _EmptyJourney extends StatelessWidget {
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
            'No journey yet',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete onboarding to get your personalised path.',
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

class _JourneyComplete extends StatelessWidget {
  const _JourneyComplete();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Center(
        child: Text(
          'You\'ve reached the end of your journey',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final _Lesson lesson;

  const _LessonRow({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 68,
          child: Center(child: _LessonNode(lesson: lesson)),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: lesson.state == _LessonState.nextUp ? 0 : 4,
            ),
            child: _LessonContent(lesson: lesson),
          ),
        ),
      ],
    );
  }
}

class _LessonConnector extends StatelessWidget {
  const _LessonConnector();

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
                painter: _DashedLinePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonNode extends StatelessWidget {
  final _Lesson lesson;

  const _LessonNode({required this.lesson});

  @override
  Widget build(BuildContext context) {
    switch (lesson.state) {
      case _LessonState.completed:
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.scoreHigh,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 24),
        );

      case _LessonState.nextUp:
        return GestureDetector(
          onTap: () => context.push('/learn/${lesson.id}'),
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

      case _LessonState.locked:
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

class _LessonContent extends StatelessWidget {
  final _Lesson lesson;

  const _LessonContent({required this.lesson});

  @override
  Widget build(BuildContext context) {
    switch (lesson.state) {
      case _LessonState.completed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LESSON ${lesson.number}',
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

      case _LessonState.nextUp:
        return Container(
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
                    'LESSON ${lesson.number} · NEXT UP',
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
                  if (lesson.level != null) _InfoChip(lesson.level!),
                  if (lesson.turns != null) ...[
                    const SizedBox(width: 6),
                    _InfoChip('${lesson.turns} turns'),
                  ],
                  if (lesson.durationMin != null) ...[
                    const SizedBox(width: 6),
                    _InfoChip('${lesson.durationMin} min'),
                  ],
                ],
              ),
            ],
          ),
        );

      case _LessonState.locked:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LESSON ${lesson.number}',
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

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip(this.label);

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

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double y = 0;

    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, (y + dashHeight).clamp(0, size.height)),
        paint,
      );
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}
