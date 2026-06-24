import 'package:equatable/equatable.dart';
import 'package:zingo/domain/dtos/user-profile/user_profile_create_dto.dart';

class UserProfileCreateEvent extends Equatable {
  const UserProfileCreateEvent();

  @override
  List<Object?> get props => [];
}

class UserProfileCreateTrigger extends UserProfileCreateEvent {
  final UserProfileCreateDto payload;

  const UserProfileCreateTrigger({required this.payload});

  @override
  List<Object?> get props => [payload];
}
