import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/constants/languages.dart';
import 'package:zingo/constants/practice_goal.dart';

class UserProfileScreenFormData extends Equatable with ChangeNotifier {
  String? displayName;
  Language? motherLanguage;
  PracticeGoal? practiceGoal;
  TimeOfDay? notificationTime;
  UserProfileScreenFormData();

  void initialize({
    required String displayName,
    Language? motherLanguage,
    PracticeGoal? practiceGoal,
    TimeOfDay? notificationTime,
  }) {
    this.displayName = displayName;
    this.motherLanguage = motherLanguage ?? this.motherLanguage;
    this.practiceGoal = practiceGoal ?? this.practiceGoal;
    this.notificationTime = notificationTime ?? this.notificationTime;
    notifyListeners();
  }

  void update({
    String? displayName,
    Language? motherLanguage,
    PracticeGoal? practiceGoal,
    TimeOfDay? notificationTime,
  }) {
    this.displayName = displayName ?? this.displayName;
    this.motherLanguage = motherLanguage ?? this.motherLanguage;
    this.practiceGoal = practiceGoal ?? this.practiceGoal;
    this.notificationTime = notificationTime ?? this.notificationTime;
    notifyListeners();
  }

  @override
  List<Object?> get props => [
    displayName,
    motherLanguage,
    practiceGoal,
    notificationTime,
  ];
}
