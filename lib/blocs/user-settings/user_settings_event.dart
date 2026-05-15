import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/user-profile/user_profile_update_dto.dart';

class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();

  @override
  List<Object?> get props => [];
}

class UserSettingsLoaded extends UserSettingsEvent {
  final String userId;

  const UserSettingsLoaded({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Saves all editable sections in one shot. Each leg only fires if its
/// corresponding value actually changed compared to the loaded state.
class UserSettingsSaved extends UserSettingsEvent {
  final String userId;
  final UserProfileUpdateDto profile;
  final EnglishLevel? cefrLevel;
  final List<String>? topicCodes;

  const UserSettingsSaved({
    required this.userId,
    required this.profile,
    this.cefrLevel,
    this.topicCodes,
  });

  @override
  List<Object?> get props => [userId, profile, cefrLevel, topicCodes];
}
