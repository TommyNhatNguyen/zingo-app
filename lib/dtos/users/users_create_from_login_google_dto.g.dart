// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_create_from_login_google_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersCreateFromLoginGoogleDto _$UsersCreateFromLoginGoogleDtoFromJson(
  Map<String, dynamic> json,
) => UsersCreateFromLoginGoogleDto(
  email: json['email'] as String,
  username: json['username'] as String,
  user_uid: json['user_uid'] as String,
);

Map<String, dynamic> _$UsersCreateFromLoginGoogleDtoToJson(
  UsersCreateFromLoginGoogleDto instance,
) => <String, dynamic>{
  'email': instance.email,
  'username': instance.username,
  'user_uid': instance.user_uid,
};
