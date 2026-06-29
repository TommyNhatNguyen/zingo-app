import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/constants/topics.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/card_select.dart';
import 'package:zingo/ui/core/ui/resize_header.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';

class InterestTopicsPage extends StatelessWidget {
  const InterestTopicsPage({super.key});

  void _onTopicToggled({
    required BuildContext context,
    required String topicCode,
  }) {
    final selected = List<String>.from(
      context.read<OnboardingViewBloc>().state.favoriteTopics ?? [],
    );
    if (selected.contains(topicCode)) {
      selected.remove(topicCode);
    } else {
      selected.add(topicCode);
    }
    context.read<OnboardingViewBloc>().add(
      OnboardingViewUpdateForm(favoriteTopics: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingViewBloc>().state;
    final selectedTopics = state.favoriteTopics ?? [];

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: ResizeHeader(
            maxHeight: 120,
            minHeight: 80,
            builder: (context, t) {
              final textTheme = Theme.of(context).textTheme;
              return ColoredBox(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('💬', style: TextStyle(fontSize: 40 - t * 16)),
                    Text(
                      'Pick at least 3 topics you like',
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize:
                            (textTheme.headlineMedium?.fontSize ?? 28) - t * 5,
                      ),
                    ),
                    Opacity(
                      opacity: (1.0 - t).clamp(0.0, 1.0),
                      child: Text(
                        "We'll personalise your dialogs based on your interests.",
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
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 2,
            children: TopicCategory.all
                .map(
                  (cat) => CardSelect(
                    emoji: cat.emoji,
                    label: cat.name,
                    isSelected: selectedTopics.contains(cat.code),
                    onTap: () =>
                        _onTopicToggled(context: context, topicCode: cat.code),
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    labelMaxLines: 2,
                    checkIconSize: 16,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
