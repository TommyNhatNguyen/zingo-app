import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/constants/languages.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/card_select.dart';
import 'package:zingo/ui/core/ui/resize_header.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';

class DisplayLanguagePage extends StatelessWidget {
  const DisplayLanguagePage({super.key});

  void _onDisplayLanguageChanged({
    required BuildContext context,
    required Language language,
  }) {
    context.read<OnboardingViewBloc>().add(
      OnboardingViewUpdateForm(displayLanguage: language),
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
                    Text('🌍', style: TextStyle(fontSize: 40 - t * 16)),
                    Text(
                      "What's your native language?",
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize:
                            (textTheme.headlineMedium?.fontSize ?? 28) - t * 5,
                      ),
                    ),
                    Opacity(
                      opacity: (1.0 - t).clamp(0.0, 1.0),
                      child: Text(
                        "We'll tailor tips and translations for you.",
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
            children: Language.all
                .map(
                  (lang) => CardSelect(
                    emoji: lang.flag,
                    label: lang.nativeName,
                    isSelected: state.displayLanguage?.code == lang.code,
                    onTap: () => _onDisplayLanguageChanged(
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
