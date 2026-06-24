import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/models/user_streak.dart';

class UserStreakGetState extends Equatable {
  const UserStreakGetState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  final UserStreak? data;
  final RequestStatus requestStatus;
  final String? error;

  factory UserStreakGetState.initial() => const UserStreakGetState();

  UserStreakGetState copyWith({
    UserStreak? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UserStreakGetState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
