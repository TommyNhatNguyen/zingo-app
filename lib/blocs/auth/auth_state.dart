import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/user_profile.dart';
import 'package:zingo/models/users.dart';

class AuthState extends Equatable {
  final Users? data;
  final UserProfile? profile;
  final User? user;
  final RequestStatus requestStatus;
  final String? error;

  const AuthState({
    required this.data,
    this.profile,
    this.user,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory AuthState.initial() {
    return const AuthState(
      data: null,
      profile: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  AuthState copyWith({
    Users? data,
    UserProfile? profile,
    User? user,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return AuthState(
      data: data ?? this.data,
      profile: profile ?? this.profile,
      user: user ?? this.user,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, profile, user, requestStatus, error];
}
