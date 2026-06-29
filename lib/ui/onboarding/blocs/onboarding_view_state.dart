import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/core/constants/languages.dart';

class OnboardingViewState extends Equatable {
  final int page;
  final int totalPage;

  final String? displayName;
  final Language? displayLanguage;
  final Language? motherLanguage;
  final int? practiceGoalPerDay;
  final TimeOfDay? notificationTime;

  const OnboardingViewState({
    required this.page,
    required this.totalPage,
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
    this.practiceGoalPerDay,
    this.notificationTime,
  });

  factory OnboardingViewState.initial() => OnboardingViewState(
    page: 0,
    totalPage: 4,
    displayName: null,
    displayLanguage: null,
    motherLanguage: null,
    practiceGoalPerDay: null,
    notificationTime: TimeOfDay.now(),
  );

  OnboardingViewState copyWith({
    int? page,
    int? totalPage,
    String? displayName,
    Language? displayLanguage,
    Language? motherLanguage,
    int? practiceGoalPerDay,
    TimeOfDay? notificationTime,
  }) {
    return OnboardingViewState(
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      displayName: displayName ?? this.displayName,
      displayLanguage: displayLanguage ?? this.displayLanguage,
      motherLanguage: motherLanguage ?? this.motherLanguage,
      practiceGoalPerDay: practiceGoalPerDay ?? this.practiceGoalPerDay,
      notificationTime: notificationTime ?? this.notificationTime,
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
    notificationTime,
  ];
}
