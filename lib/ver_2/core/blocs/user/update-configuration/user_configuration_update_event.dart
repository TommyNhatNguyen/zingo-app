import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/user-configuration/user_configuration_update_dto.dart';

class UserConfigurationUpdateEvent extends Equatable {
  const UserConfigurationUpdateEvent();

  @override
  List<Object?> get props => [];
}

class UserConfigurationUpdateTriggered extends UserConfigurationUpdateEvent {
  final String userId;
  final UserConfigurationUpdateDto payload;

  const UserConfigurationUpdateTriggered({
    required this.userId,
    required this.payload,
  });

  @override
  List<Object?> get props => [userId];
}
