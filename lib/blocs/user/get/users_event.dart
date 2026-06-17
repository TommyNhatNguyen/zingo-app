import 'package:equatable/equatable.dart';

class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class UsersRegister extends UsersEvent {
  final String username;
  final String email;
  final String password;

  const UsersRegister({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}
