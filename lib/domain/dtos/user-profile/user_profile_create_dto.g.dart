// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_create_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileCreateDto _$UserProfileCreateDtoFromJson(
  Map<String, dynamic> json,
) => UserProfileCreateDto(
  user_id: json['user_id'] as String,
  cefr_level: $enumDecode(_$EnglishLevelEnumMap, json['cefr_level']),
  display_name: json['display_name'] as String,
  mother_language: json['mother_language'] as String,
  display_language: json['display_language'] as String,
  practice_goal_per_day: (json['practice_goal_per_day'] as num?)?.toInt(),
  notification_time: json['notification_time'] as String?,
  favorite_topics: (json['favorite_topics'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserProfileCreateDtoToJson(
  UserProfileCreateDto instance,
) => <String, dynamic>{
  'user_id': instance.user_id,
  'cefr_level': _$EnglishLevelEnumMap[instance.cefr_level]!,
  'display_name': instance.display_name,
  'mother_language': instance.mother_language,
  'display_language': instance.display_language,
  'practice_goal_per_day': instance.practice_goal_per_day,
  'notification_time': instance.notification_time,
  'favorite_topics': instance.favorite_topics,
};

const _$EnglishLevelEnumMap = {
  EnglishLevel.A1: 'A1',
  EnglishLevel.A2: 'A2',
  EnglishLevel.B1: 'B1',
  EnglishLevel.B2: 'B2',
  EnglishLevel.C1: 'C1',
  EnglishLevel.C2: 'C2',
};
