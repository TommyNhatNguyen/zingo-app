import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_create_from_login_google_dto.g.dart';

@JsonSerializable()
class UsersCreateFromLoginGoogleDto extends Equatable {
  final String email;
  final String username;
  final String user_uid;

  const UsersCreateFromLoginGoogleDto({
    required this.email,
    required this.username,
    required this.user_uid,
  });

  factory UsersCreateFromLoginGoogleDto.fromJson(Map<String, dynamic> json) =>
      _$UsersCreateFromLoginGoogleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UsersCreateFromLoginGoogleDtoToJson(this);

  @override
  List<Object?> get props => [email, username, user_uid];
}
