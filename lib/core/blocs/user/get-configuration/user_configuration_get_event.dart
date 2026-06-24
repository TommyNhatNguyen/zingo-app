import 'package:equatable/equatable.dart';
import 'package:zingo/domain/models/user_profile.dart';

class UserConfigurationGetEvent extends Equatable {
  const UserConfigurationGetEvent();

  @override
  List<Object?> get props => [];
}

class UserConfigurationGetFetched extends UserConfigurationGetEvent {
  final String userId;

  const UserConfigurationGetFetched({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UserConfigurationGetReset extends UserConfigurationGetEvent {
  const UserConfigurationGetReset();

  @override
  List<Object?> get props => [];
}

class UserConfigurationGetProfileUpdated extends UserConfigurationGetEvent {
  final UserProfile profile;

  const UserConfigurationGetProfileUpdated({required this.profile});

  @override
  List<Object?> get props => [profile];
}