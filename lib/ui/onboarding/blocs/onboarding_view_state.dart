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
  final List<String>? favoriteTopics;

  const OnboardingViewState({
    required this.page,
    required this.totalPage,
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
    this.practiceGoalPerDay,
    this.notificationTime,
    this.favoriteTopics,
  });

  factory OnboardingViewState.initial() => OnboardingViewState(
    page: 0,
    totalPage: 5,
    displayName: null,
    displayLanguage: null,
    motherLanguage: null,
    practiceGoalPerDay: null,
    notificationTime: TimeOfDay.now(),
    favoriteTopics: [],
  );

  OnboardingViewState copyWith({
    int? page,
    int? totalPage,
    String? displayName,
    Language? displayLanguage,
    Language? motherLanguage,
    int? practiceGoalPerDay,
    TimeOfDay? notificationTime,
    List<String>? favoriteTopics,
  }) {
    return OnboardingViewState(
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      displayName: displayName ?? this.displayName,
      displayLanguage: displayLanguage ?? this.displayLanguage,
      motherLanguage: motherLanguage ?? this.motherLanguage,
      practiceGoalPerDay: practiceGoalPerDay ?? this.practiceGoalPerDay,
      notificationTime: notificationTime ?? this.notificationTime,
      favoriteTopics: favoriteTopics ?? this.favoriteTopics,
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
    favoriteTopics,
  ];
}
