import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/user/get-streak/user_streak_get_bloc.dart';
import 'package:zingo/blocs/user/get-streak/user_streak_get_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/config/app_text_styles.dart';
import 'package:zingo/l10n/l10n.dart';
import 'package:zingo/models/user_profile.dart';

class HomeStreakCard extends StatelessWidget {
  const HomeStreakCard({super.key, required this.profile});

  final UserProfile? profile;

  static String _monthYearLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '$month/${date.year}';
  }

  static String _dayLabel(DateTime date) => date.day.toString().padLeft(2, '0');

  static String _streakDateKey(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  static List<DateTime> _currentWeekDays() {
    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final streakDays = profile?.streak ?? 0;
    final bestStreak = profile?.longest_streak ?? 0;

    return BlocBuilder<UserStreakGetBloc, UserStreakGetState>(
      builder: (context, streakState) {
        final streakDates = streakState.data?.streak_dates ?? {};
        final weekDays = _currentWeekDays();
        final today = DateTime.now();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _monthYearLabel(today),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.streak.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.streak,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.dailyStreak,
                        style: AppTextStyles.bodySmall,
                      ),
                      Text(
                        context.l10n.streakDaysCount(streakDays),
                        style: AppTextStyles.h2,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        context.l10n.bestStreakLabel,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        context.l10n.streakDaysCount(bestStreak),
                        style: AppTextStyles.h2,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 7; i++)
                    StreakDayCell(
                      label: _dayLabel(weekDays[i]),
                      isToday: _isSameDay(weekDays[i], today),
                      isCompleted:
                          streakDates[_streakDateKey(weekDays[i])] == true,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

enum StreakDayCellState { completed, today, inactive }

class StreakDayCell extends StatelessWidget {
  const StreakDayCell({
    super.key,
    required this.label,
    required this.isToday,
    required this.isCompleted,
  });

  final String label;
  final bool isToday;
  final bool isCompleted;

  StreakDayCellState get _state {
    if (isCompleted) return StreakDayCellState.completed;
    if (isToday) return StreakDayCellState.today;
    return StreakDayCellState.inactive;
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 11,
            color: state == StreakDayCellState.inactive
                ? AppColors.textDisabled
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        _buildIcon(state),
      ],
    );
  }

  Widget _buildIcon(StreakDayCellState state) {
    final Color backgroundColor;
    final Color iconColor;

    switch (state) {
      case StreakDayCellState.completed:
        backgroundColor = AppColors.accentContainer;
        iconColor = AppColors.streak;
      case StreakDayCellState.today:
        backgroundColor = Colors.transparent;
        iconColor = AppColors.primary;
      case StreakDayCellState.inactive:
        backgroundColor = AppColors.border.withValues(alpha: 0.5);
        iconColor = AppColors.textDisabled;
    }

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: isToday ? Border.all(color: AppColors.streak, width: 2) : null,
      ),
      child: Icon(
        Icons.local_fire_department_rounded,
        color: iconColor,
        size: 19,
      ),
    );
  }
}
