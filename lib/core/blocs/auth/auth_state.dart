import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/models/users.dart';

class AuthState extends Equatable {
  final Users? data;
  final User? user;
  final RequestStatus requestStatus;
  final String? error;

  const AuthState({
    required this.data,
    this.user,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory AuthState.initial() {
    return const AuthState(
      data: null,
      user: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  factory AuthState.loggedOut() {
    return const AuthState(
      data: null,
      user: null,
      requestStatus: RequestStatus.success,
      error: null,
    );
  }

  AuthState copyWith({
    Users? data,
    User? user,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return AuthState(
      data: data ?? this.data,
      user: user ?? this.user,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, user, requestStatus, error];
}
