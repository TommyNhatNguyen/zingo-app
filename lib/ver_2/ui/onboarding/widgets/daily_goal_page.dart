import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/practice_goal.dart';
import 'package:zingo/ver_2/ui/onboarding/widgets/profile_page.dart';

class DailyGoalPage extends StatefulWidget {
  const DailyGoalPage({super.key, this.selectedGoal, required this.onSelect});

  final PracticeGoal? selectedGoal;
  final ValueChanged<PracticeGoal> onSelect;

  @override
  _DailyGoalPageState createState() => _DailyGoalPageState();
}

class _DailyGoalPageState extends State<DailyGoalPage> {
  void _selectDailyGoal(int? value) {
    final goal = PracticeGoal.all.firstWhere((goal) => goal.value == value);
    setState(() {
      widget.onSelect(goal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      emoji: "🎯",
      title: "Set your daily goal",
      description: "How many dialogs do you want to practice each day?",
      child: Expanded(
        child: RadioGroup(
          groupValue: widget.selectedGoal?.value,
          onChanged: (value) => _selectDailyGoal(value),
          child: ListView.separated(
            itemBuilder: (context, index) =>
                _buildDailyGoalCard(PracticeGoal.all[index]),
            itemCount: PracticeGoal.all.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard(PracticeGoal goal) {
    return InkWell(
      onTap: () => _selectDailyGoal(goal.value),
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                goal.emoji,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(width: 16),
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
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Radio(value: goal.value),
            ],
          ),
        ),
      ),
    );
  }
}
