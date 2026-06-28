import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/languages.dart';

class OnboardingViewState extends Equatable {
  final int page;
  final int totalPage;

  final String? displayName;
  final Language? displayLanguage;
  final Language? motherLanguage;
  final int? practiceGoalPerDay;

  const OnboardingViewState({
    required this.page,
    required this.totalPage,
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
    this.practiceGoalPerDay,
  });

  factory OnboardingViewState.initial() => const OnboardingViewState(
    page: 0,
    totalPage: 4,
    displayName: null,
    displayLanguage: null,
    motherLanguage: null,
    practiceGoalPerDay: null,
  );

  OnboardingViewState copyWith({
    int? page,
    int? totalPage,
    String? displayName,
    Language? displayLanguage,
    Language? motherLanguage,
    int? practiceGoalPerDay,
  }) {
    return OnboardingViewState(
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      displayName: displayName ?? this.displayName,
      displayLanguage: displayLanguage ?? this.displayLanguage,
      motherLanguage: motherLanguage ?? this.motherLanguage,
      practiceGoalPerDay: practiceGoalPerDay ?? this.practiceGoalPerDay,
    );
  }

  @override
  List<Object?> get props => [
    page,
    totalPage,
    displayName,
    displayLanguage,
    motherLanguage,
    practiceGoalPerDay,
  ];
}
