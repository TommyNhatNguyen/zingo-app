import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class LoginDto extends Equatable {
  final String email;
  final String password;

  const LoginDto({
    required this.email,
    required this.password,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);

  @override
  List<Object?> get props => [email, password];
}
