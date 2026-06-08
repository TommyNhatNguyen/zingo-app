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
  cefr_level: json['cefr_level'] as String,
  level: json['level'] as String,
  xp: (json['xp'] as num).toInt(),
  streak: (json['streak'] as num).toInt(),
  longest_streak: (json['longest_streak'] as num).toInt(),
  last_practice_at: json['last_practice_at'] == null
      ? null
      : DateTime.parse(json['last_practice_at'] as String),
  created_at: DateTime.parse(json['created_at'] as String),
  updated_at: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deleted_at: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  currentWeekStreak: (json['currentWeekStreak'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
);

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
  'id': instance.id,
  'user_uid': instance.user_uid,
  'email': instance.email,
  'username': instance.username,
  'cefr_level': instance.cefr_level,
  'level': instance.level,
  'xp': instance.xp,
  'streak': instance.streak,
  'longest_streak': instance.longest_streak,
  'last_practice_at': instance.last_practice_at?.toIso8601String(),
  'created_at': instance.created_at.toIso8601String(),
  'updated_at': instance.updated_at?.toIso8601String(),
  'deleted_at': instance.deleted_at?.toIso8601String(),
  'currentWeekStreak': instance.currentWeekStreak,
};
