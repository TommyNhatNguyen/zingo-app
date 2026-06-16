import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zingo/dtos/user-profile/user_profile_update_dto.dart';
import 'package:zingo/models/user_profile.dart';

class UserProfileFormData extends Equatable with ChangeNotifier {
  late UserProfileUpdateDto payload;

  UserProfileFormData({required this.payload});

  void initialize(UserProfile user) {
    this.payload = UserProfileUpdateDto(
      display_name: user.display_name,
      mother_language: user.mother_language,
      display_language: user.display_language,
      practice_goal_per_day: user.practice_goal_per_day,
      notification_time: user.notification_time,
    );
  }

  void update(UserProfileUpdateDto payload) {
    this.payload = this.payload.copyWith(
      display_name: payload.display_name,
      mother_language: payload.mother_language,
      display_language: payload.display_language,
      practice_goal_per_day: payload.practice_goal_per_day,
      notification_time: payload.notification_time,
    );
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
