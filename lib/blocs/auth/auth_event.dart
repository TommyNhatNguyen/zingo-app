import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/dtos/auth/login_dto.dart';

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

class AuthLoginWithAnonymous extends AuthEvent {
  const AuthLoginWithAnonymous();

  @override
  List<Object?> get props => [];
}

class AuthStateChanged extends AuthEvent {
  final User user;

  const AuthStateChanged({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();

  @override
  List<Object?> get props => [];
}
