import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/constants/enums.dart';

class AuthState extends Equatable {
  final User? data;
  final RequestStatus requestStatus;
  final String? error;

  const AuthState({
    required this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory AuthState.initial() {
    return const AuthState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  AuthState copyWith({
    User? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return AuthState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
