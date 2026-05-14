import 'package:equatable/equatable.dart';
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
