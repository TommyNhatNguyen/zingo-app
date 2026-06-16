import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/user_profile.dart';

class UserProfileViewState extends Equatable {
  final UserProfile? profile;
  final RequestStatus requestStatus;
  final String? error;

  const UserProfileViewState({
    this.profile,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory UserProfileViewState.initial() {
    return const UserProfileViewState(
      profile: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  UserProfileViewState copyWith({
    UserProfile? profile,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UserProfileViewState(
      profile: profile ?? this.profile,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [profile, requestStatus, error];
}
