import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/config/app_text_styles.dart';

enum StreakDayCellState { completed, today, inactive }

class StreakWeekView extends StatelessWidget {
  const StreakWeekView({
    super.key,
    required this.streakDates,
    this.referenceDate,
    this.cellAnimations,
  });

  final Map<String, bool> streakDates;
  final DateTime? referenceDate;
  final List<Animation<double>>? cellAnimations;

  static String monthYearLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '$month/${date.year}';
  }

  static String dayLabel(DateTime date) =>
      date.day.toString().padLeft(2, '0');

  static String streakDateKey(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  static List<DateTime> currentWeekDays(DateTime reference) {
    final monday = DateTime(
      reference.year,
      reference.month,
      reference.day,
    ).subtract(Duration(days: reference.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final today = referenceDate ?? DateTime.now();
    final weekDays = currentWeekDays(today);
    final showMonthYear = cellAnimations == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMonthYear) ...[
          Text(
            monthYearLabel(today),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < weekDays.length; i++)
              _animatedCell(
                index: i,
                child: StreakDayCell(
                  label: dayLabel(weekDays[i]),
                  isToday: isSameDay(weekDays[i], today),
                  isCompleted:
                      streakDates[streakDateKey(weekDays[i])] == true,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _animatedCell({required int index, required Widget child}) {
    final animation = cellAnimations;
    if (animation == null || index >= animation.length) return child;

    return FadeTransition(
      opacity: animation[index],
      child: ScaleTransition(
        scale: animation[index],
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }
}

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
