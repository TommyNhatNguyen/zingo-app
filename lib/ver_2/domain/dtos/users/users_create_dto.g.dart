// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_create_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersCreateDto _$UsersCreateDtoFromJson(Map<String, dynamic> json) =>
    UsersCreateDto(
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UsersCreateDtoToJson(UsersCreateDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
    };
