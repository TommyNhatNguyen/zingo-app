import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/features/onboarding/widgets/profile_page.dart';

class EnglishLevelPage extends StatelessWidget {
  const EnglishLevelPage({
    super.key,
    required this.selectedLevel,
    required this.onSelect,
  });

  final EnglishLevel? selectedLevel;
  final ValueChanged<EnglishLevel> onSelect;

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      emoji: '📊',
      title: "What's your English level?",
      description: "We'll match dialogs to your comfort zone.",
      child: Expanded(
        child: ListView.separated(
          itemCount: EnglishLevel.values.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              _buildLevelCard(context, EnglishLevel.values[index]),
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, EnglishLevel level) {
    final isSelected = selectedLevel == level;
    return InkWell(
      onTap: () => onSelect(level),
      child: Card.outlined(
        color: isSelected ? AppColors.primaryContainer : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${level.value.toUpperCase()} · ${level.label}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      level.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
