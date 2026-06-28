import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/languages.dart';

sealed class OnboardingViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingViewGoToPage extends OnboardingViewEvent {
  final int page;

  OnboardingViewGoToPage({required this.page});

  @override
  List<Object?> get props => [page];
}

class OnboardingViewUpdateForm extends OnboardingViewEvent {
  final String? displayName;
  final Language? displayLanguage;
  final Language? motherLanguage;
  final int? practiceGoalPerDay;
  OnboardingViewUpdateForm({
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
    this.practiceGoalPerDay,
  });

  @override
  List<Object?> get props => [
    displayName,
    displayLanguage,
    motherLanguage,
    practiceGoalPerDay,
  ];
}
