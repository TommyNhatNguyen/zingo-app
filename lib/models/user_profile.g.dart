// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  cefr_level: json['cefr_level'] as String,
  level: json['level'] as String,
  xp: (json['xp'] as num).toInt(),
  streak: (json['streak'] as num).toInt(),
  longest_streak: (json['longest_streak'] as num).toInt(),
  last_practice_at: json['last_practice_at'] == null
      ? null
      : DateTime.parse(json['last_practice_at'] as String),
  currentWeekStreak: (json['currentWeekStreak'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
  created_at: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updated_at: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deleted_at: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  user_id: json['user_id'] as String,
  display_name: json['display_name'] as String?,
  mother_language: json['mother_language'] as String?,
  display_language: json['display_language'] as String?,
  practice_goal_per_day: (json['practice_goal_per_day'] as num?)?.toInt(),
  notification_time: json['notification_time'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'display_name': instance.display_name,
      'mother_language': instance.mother_language,
      'display_language': instance.display_language,
      'practice_goal_per_day': instance.practice_goal_per_day,
      'notification_time': instance.notification_time,
      'cefr_level': instance.cefr_level,
      'level': instance.level,
      'xp': instance.xp,
      'streak': instance.streak,
      'longest_streak': instance.longest_streak,
      'last_practice_at': instance.last_practice_at?.toIso8601String(),
      'currentWeekStreak': instance.currentWeekStreak,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
