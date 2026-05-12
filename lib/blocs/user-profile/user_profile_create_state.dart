import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/user_profile.dart';

class UserProfileCreateState extends Equatable {
  final UserProfile? data;
  final RequestStatus requestStatus;
  final String? error;

  const UserProfileCreateState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory UserProfileCreateState.initial() {
    return const UserProfileCreateState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  UserProfileCreateState copyWith({
    UserProfile? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UserProfileCreateState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
