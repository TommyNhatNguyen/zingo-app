import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/dtos/user-profile/user_profile_update_dto.dart';
import 'package:zingo/models/user_profile.dart';

class UserProfileScreenFormData extends Equatable with ChangeNotifier {
  UserProfileUpdateDto payload = UserProfileUpdateDto();

  UserProfileScreenFormData();

  void initialize(UserProfile user) {
    payload = UserProfileUpdateDto(
      display_name: user.display_name,
      mother_language: user.mother_language,
    );
  }

  void updateName(String? name) {
    payload = payload.copyWith(display_name: name);
    notifyListeners();
  }

  void updateMotherLanguage(String? language) {
    payload = payload.copyWith(mother_language: language);
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
  List<Object?> get props => [payload];
}
