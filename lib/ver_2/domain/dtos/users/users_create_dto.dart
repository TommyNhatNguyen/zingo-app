import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_create_dto.g.dart';

@JsonSerializable()
class UsersCreateDto extends Equatable {
  final String email;
  final String username;
  final String password;

  const UsersCreateDto({
    required this.email,
    required this.username,
    required this.password,
  });

  factory UsersCreateDto.fromJson(Map<String, dynamic> json) =>
      _$UsersCreateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UsersCreateDtoToJson(this);

  @override
  List<Object?> get props => [email, username, password];
}
