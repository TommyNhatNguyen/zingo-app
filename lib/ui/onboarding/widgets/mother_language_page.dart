import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/constants/languages.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/card_select.dart';
import 'package:zingo/ui/core/ui/resize_header.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';

class MotherLanguagePage extends StatelessWidget {
  const MotherLanguagePage({super.key});

  void _onMotherLanguageChanged({
    required BuildContext context,
    required Language language,
  }) {
    context.read<OnboardingViewBloc>().add(
      OnboardingViewUpdateForm(motherLanguage: language),
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
                    Text('👩', style: TextStyle(fontSize: 40 - t * 16)),
                    Text(
                      "What's your mother language?",
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize:
                            (textTheme.headlineMedium?.fontSize ?? 28) - t * 5,
                      ),
                    ),
                    const SizedBox(height: 16),
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
            children: Language.all
                .map(
                  (lang) => CardSelect(
                    emoji: lang.flag,
                    label: lang.nativeName,
                    isSelected: state.motherLanguage?.code == lang.code,
                    onTap: () => _onMotherLanguageChanged(
                      context: context,
                      language: lang,
                    ),
                    emojiStyle: Theme.of(context).textTheme.displayMedium,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
