import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/user-streak/get_user_streak_payload.dart';

class UserStreakGetEvent extends Equatable {
  const UserStreakGetEvent();

  @override
  List<Object?> get props => [];
}

class UserStreakGetFetched extends UserStreakGetEvent {
  final GetUserStreakPayload payload;

  const UserStreakGetFetched({required this.payload});

  @override
  List<Object?> get props => [payload];
}
