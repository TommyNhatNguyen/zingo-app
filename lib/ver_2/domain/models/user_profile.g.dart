// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  cefr_level: $enumDecode(_$EnglishLevelEnumMap, json['cefr_level']),
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
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'display_name': instance.display_name,
      'mother_language': instance.mother_language,
      'cefr_level': _$EnglishLevelEnumMap[instance.cefr_level]!,
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

const _$EnglishLevelEnumMap = {
  EnglishLevel.A1: 'A1',
  EnglishLevel.A2: 'A2',
  EnglishLevel.B1: 'B1',
  EnglishLevel.B2: 'B2',
  EnglishLevel.C1: 'C1',
  EnglishLevel.C2: 'C2',
};
