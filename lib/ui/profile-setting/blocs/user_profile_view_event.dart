import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/constants/languages.dart';
import 'package:zingo/core/constants/practice_goal.dart';

sealed class UserProfileViewEvent extends Equatable {}

class UserProfileViewUpdateForm extends UserProfileViewEvent {
  final String? displayName;
  final Language? displayLanguage;
  final Language? motherLanguage;
  final EnglishLevel? englishLevel;
  final PracticeGoal? practiceGoal;
  final TimeOfDay? notificationTime;
  final List<String>? favoriteTopics;

  UserProfileViewUpdateForm({
    this.displayName,
    this.displayLanguage,
    this.motherLanguage,
    this.englishLevel,
    this.practiceGoal,
    this.notificationTime,
    this.favoriteTopics,
  });

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
