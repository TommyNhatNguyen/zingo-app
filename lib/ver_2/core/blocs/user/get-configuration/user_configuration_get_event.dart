import 'package:equatable/equatable.dart';

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
