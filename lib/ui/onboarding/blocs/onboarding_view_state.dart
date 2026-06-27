import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/languages.dart';

class OnboardingViewState extends Equatable {
  final int page;
  final int totalPage;

  final String? displayName;
  final Language? displayLanguage;
  final Language? motherLanguage;

  const OnboardingViewState({
    required this.page,
    required this.totalPage,
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
  });

  factory OnboardingViewState.initial() => const OnboardingViewState(
    page: 0,
    totalPage: 3,
    displayName: null,
    displayLanguage: null,
    motherLanguage: null,
  );

  OnboardingViewState copyWith({
    int? page,
    int? totalPage,
    String? displayName,
    Language? displayLanguage,
    Language? motherLanguage,
  }) {
    return OnboardingViewState(
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      displayName: displayName ?? this.displayName,
      displayLanguage: displayLanguage ?? this.displayLanguage,
      motherLanguage: motherLanguage ?? this.motherLanguage,
    );
  }

  @override
  List<Object?> get props => [
    page,
    totalPage,
    displayName,
    displayLanguage,
    motherLanguage,
  ];
}
