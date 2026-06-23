// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
  id: json['id'] as String,
  user_uid: json['user_uid'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  created_at: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updated_at: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deleted_at: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
  'id': instance.id,
  'user_uid': instance.user_uid,
  'email': instance.email,
  'username': instance.username,
  'created_at': instance.created_at?.toIso8601String(),
  'updated_at': instance.updated_at?.toIso8601String(),
  'deleted_at': instance.deleted_at?.toIso8601String(),
};
