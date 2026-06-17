import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/constants/languages.dart';

class UserProfileScreenFormData extends Equatable with ChangeNotifier {
  String? displayName;
  Language? motherLanguage;
  UserProfileScreenFormData();

  void initialize({
    required String displayName,
    Language? motherLanguage,
  }) {
    this.displayName = displayName;
    this.motherLanguage = motherLanguage ?? this.motherLanguage;
    notifyListeners();
  }

  void update({String? displayName, Language? motherLanguage}) {
    this.displayName = displayName ?? this.displayName;
    this.motherLanguage = motherLanguage ?? this.motherLanguage;
    notifyListeners();
  }

  TimeOfDay? parseTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  List<Object?> get props => [displayName, motherLanguage];
}
