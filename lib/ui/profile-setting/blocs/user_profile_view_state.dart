import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/constants/languages.dart';
import 'package:zingo/core/constants/practice_goal.dart';

class UserProfileViewState extends Equatable {
  final String? displayName;
  final Language? displayLanguage;
  final Language? motherLanguage;
  final EnglishLevel? englishLevel;
  final PracticeGoal? practiceGoal;
  final TimeOfDay? notificationTime;
  final List<String> favoriteTopics;

  const UserProfileViewState({
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
    this.englishLevel,
    this.practiceGoal,
    this.notificationTime,
    this.favoriteTopics = const [],
  });

  factory UserProfileViewState.initial() => const UserProfileViewState(
    displayName: null,
    displayLanguage: null,
    motherLanguage: null,
    englishLevel: null,
    practiceGoal: null,
    notificationTime: null,
    favoriteTopics: [],
  );

  UserProfileViewState copyWith({
    String? displayName,
    Language? displayLanguage,
    Language? motherLanguage,
    EnglishLevel? englishLevel,
    PracticeGoal? practiceGoal,
    TimeOfDay? notificationTime,
    List<String>? favoriteTopics,
  }) => UserProfileViewState(
    displayName: displayName ?? this.displayName,
    displayLanguage: displayLanguage ?? this.displayLanguage,
    motherLanguage: motherLanguage ?? this.motherLanguage,
    englishLevel: englishLevel ?? this.englishLevel,
    practiceGoal: practiceGoal ?? this.practiceGoal,
    notificationTime: notificationTime ?? this.notificationTime,
    favoriteTopics: favoriteTopics ?? this.favoriteTopics,
  );

  @override
  List<Object?> get props => [
    displayName,
    displayLanguage,
    motherLanguage,
    englishLevel,
    practiceGoal,
    notificationTime,
    favoriteTopics,
  ];
}
