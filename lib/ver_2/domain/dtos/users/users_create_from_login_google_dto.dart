import 'package:equatable/equatable.dart';

class UsersCreateFromLoginGoogleDto extends Equatable {
  final String email;
  final String username;
  final String user_uid;

  const UsersCreateFromLoginGoogleDto({
    required this.email,
    required this.username,
    required this.user_uid,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'user_uid': user_uid,
  };

  @override
  List<Object?> get props => [email, username, user_uid];
}
