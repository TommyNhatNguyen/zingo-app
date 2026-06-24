import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDto extends Equatable {
  final String email;
  final String password;

  const RegisterDto({required this.email, required this.password});

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  @override
  List<Object?> get props => [email, password];
}
