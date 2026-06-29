import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/resize_header.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';

class EnglishLevelPage extends StatelessWidget {
  const EnglishLevelPage({super.key});

  void _onLevelChanged({
    required BuildContext context,
    required EnglishLevel level,
  }) {
    context.read<OnboardingViewBloc>().add(
      OnboardingViewUpdateForm(englishLevel: level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingViewBloc>().state;
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: ResizeHeader(
            maxHeight: 115.0,
            minHeight: 82.0,
            builder: (context, t) {
              final textTheme = Theme.of(context).textTheme;
              return ColoredBox(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('📊', style: TextStyle(fontSize: 40 - t * 16)),
                    Text(
                      "What's your English level?",
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize:
                            (textTheme.headlineMedium?.fontSize ?? 28) - t * 5,
                      ),
                    ),
                    Opacity(
                      opacity: (1.0 - t).clamp(0.0, 1.0),
                      child: Text(
                        "We'll match dialogs to your golden zone for growth.",
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          sliver: SliverList.separated(
            itemCount: EnglishLevel.values.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final level = EnglishLevel.values[index];
              final isSelected = state.englishLevel == level;
              return Card.outlined(
                color: isSelected ? AppColors.primaryContainer : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textDisabled,
                  ),
                ),
                child: InkWell(
                  onTap: () => _onLevelChanged(context: context, level: level),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${level.value.toUpperCase()} · ${level.label}',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.primary
                                          : null,
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
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
