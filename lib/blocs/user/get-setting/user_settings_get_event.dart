import 'package:equatable/equatable.dart';

class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();

  @override
  List<Object?> get props => [];
}

class UserSettingsGetFetched extends UserSettingsEvent {
  final String userId;

  const UserSettingsGetFetched({required this.userId});

  @override
  List<Object?> get props => [userId];
}
