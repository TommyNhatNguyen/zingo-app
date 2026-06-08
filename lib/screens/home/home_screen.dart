import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/config/app_text_styles.dart';
import 'package:zingo/models/users.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.data;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GreetingRow(user: user),
                  const SizedBox(height: 14),
                  _StreakCard(user: user),
                  const SizedBox(height: 28),
                  const _LessonPath(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

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

// ─── Streak Card ─────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final Users? user;

  const _StreakCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final streakDays = user?.streak ?? 0;
    final bestStreak = user?.longest_streak ?? 0;
    // weekday: 1=Mon…7=Sun → 0-based Mon-first index
    final todayIndex = DateTime.now().weekday - 1;
    // currentWeekStreak keys: 0=Monday, 1=Tuesday…6=Sunday (same as congrats screen)
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
                  // Home screen is Mon-first (i=0→Mon).
                  // Map key is Monday-first (0=Monday,1=Tuesday…6=Sunday): key = i
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

// ─── Lesson Path ─────────────────────────────────────────────────────────────

enum _LessonState { completed, nextUp, locked }

class _Lesson {
  final int number;
  final String title;
  final _LessonState state;
  final int? score;
  final String? level;
  final int? turns;
  final int? durationMin;
  final int? xpGain;

  const _Lesson({
    required this.number,
    required this.title,
    required this.state,
    this.score,
    this.level,
    this.turns,
    this.durationMin,
    this.xpGain,
  });
}

class _LessonPath extends StatelessWidget {
  const _LessonPath();

  static const _lessons = [
    _Lesson(
      number: 1,
      title: 'Ordering a coffee to go',
      state: _LessonState.completed,
      score: 85,
    ),
    _Lesson(
      number: 2,
      title: 'Choosing a pastry at the counter',
      state: _LessonState.completed,
      score: 78,
    ),
    _Lesson(
      number: 3,
      title: 'Sending back a wrong order',
      state: _LessonState.nextUp,
      level: 'A2',
      turns: 5,
      durationMin: 2,
      xpGain: 45,
    ),
    _Lesson(
      number: 4,
      title: 'Chatting with a friendly barista',
      state: _LessonState.locked,
    ),
    _Lesson(
      number: 5,
      title: 'Reserving a table for two',
      state: _LessonState.locked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                  'YOUR CAFÉ & FOOD PATH',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textPrimary,
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
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text('3 of 8', style: AppTextStyles.labelMedium),
          ],
        ),
        const SizedBox(height: 20),
        for (int i = 0; i < _lessons.length; i++) ...[
          _LessonRow(lesson: _lessons[i]),
          if (i < _lessons.length - 1) const _LessonConnector(),
        ],
      ],
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
        return Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.scoreHigh,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (lesson.score != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${lesson.score}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.star_rounded, color: AppColors.xp, size: 13),
                ],
              ),
            ],
          ],
        );

      case _LessonState.nextUp:
        return GestureDetector(
          onTap: () {},
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
