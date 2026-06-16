import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/user_profile.dart';

class UserProfileGetState extends Equatable {
  final UserProfile? data;
  final RequestStatus requestStatus;
  final String? error;

  const UserProfileGetState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory UserProfileGetState.initial() {
    return const UserProfileGetState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  UserProfileGetState copyWith({
    UserProfile? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UserProfileGetState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
