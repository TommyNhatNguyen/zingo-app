import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/constants/languages.dart';

sealed class OnboardingViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingViewSubmit extends OnboardingViewEvent {
  OnboardingViewSubmit();

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
  final EnglishLevel? englishLevel;
  final int? practiceGoalPerDay;
  final TimeOfDay? notificationTime;
  final List<String>? favoriteTopics;
  OnboardingViewUpdateForm({
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
    this.englishLevel,
    this.practiceGoalPerDay,
    this.notificationTime,
    this.favoriteTopics,
  });

  @override
  List<Object?> get props => [
    displayName,
    displayLanguage,
    motherLanguage,
    englishLevel,
    practiceGoalPerDay,
    notificationTime,
    favoriteTopics,
  ];
}
