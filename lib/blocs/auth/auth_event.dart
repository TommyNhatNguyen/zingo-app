import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/auth/login_dto.dart';
import 'package:zingo/models/users.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginWithEmailAndPassword extends AuthEvent {
  final LoginDto payload;

  const AuthLoginWithEmailAndPassword({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class AuthLoginWithGoogle extends AuthEvent {
  const AuthLoginWithGoogle();

  @override
  List<Object?> get props => [];
}

/// Sync [AuthState] from [FirebaseAuth.instance.currentUser] (app start / resume).
class AuthRestoreSession extends AuthEvent {
  const AuthRestoreSession();
}

/// Pushes API user into state (e.g. after `/v1/register` when Firebase may not be signed in).
class AuthApplyBackendUser extends AuthEvent {
  final Users data;

  const AuthApplyBackendUser({required this.data});

  @override
  List<Object?> get props => [data];
}
