import 'package:flutter/material.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/core/constants/practice_goal.dart';

class PracticeGoalPicker extends StatelessWidget {
  final PracticeGoal? value;
  final ValueChanged<PracticeGoal?> onSelect;
  final String emptyLabel;
  final String sheetTitle;
  final String? sheetSubtitle;
  final Widget Function({
    required Future<void> Function() openModalBottomSheet,
  })?
  trigger;

  const PracticeGoalPicker({
    super.key,
    this.value,
    required this.onSelect,
    this.emptyLabel = 'Pick a goal',
    this.sheetTitle = 'Daily practice goal',
    this.sheetSubtitle,
    this.trigger,
  });

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<PracticeGoal?>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: AppColors.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PracticeGoalSheet(
        value: value,
        title: sheetTitle,
        subtitle: sheetSubtitle,
      ),
    );
    if (result != null) onSelect(result);
  }

  @override
  Widget build(BuildContext context) {
    if (trigger != null) {
      return trigger!(
        openModalBottomSheet: () => _open(context),
      );
    }

    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(12),
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value?.emoji ?? '🎯',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value?.label ?? emptyLabel,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: value == null ? AppColors.textSecondary : null,
                      ),
                    ),
                    if (value != null)
                      Text(
                        value!.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeGoalSheet extends StatelessWidget {
  final PracticeGoal? value;
  final String title;
  final String? subtitle;

  const _PracticeGoalSheet({
    required this.value,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null)
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: PracticeGoal.all.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final goal = PracticeGoal.all[index];
                final isSelected = value == goal;
                return _GoalTile(
                  goal: goal,
                  isSelected: isSelected,
                  onTap: () => Navigator.of(
                    context,
                  ).pop(isSelected ? null : goal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final PracticeGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalTile({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: isSelected ? AppColors.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.textDisabled,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                goal.emoji,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goal.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
