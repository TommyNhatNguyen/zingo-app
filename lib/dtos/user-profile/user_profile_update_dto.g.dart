// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileUpdateDto _$UserProfileUpdateDtoFromJson(
  Map<String, dynamic> json,
) => UserProfileUpdateDto(
  display_name: json['display_name'] as String?,
  mother_language: json['mother_language'] as String?,
  display_language: json['display_language'] as String?,
  practice_goal_per_day: (json['practice_goal_per_day'] as num?)?.toInt(),
  notification_time: json['notification_time'] as String?,
);

Map<String, dynamic> _$UserProfileUpdateDtoToJson(
  UserProfileUpdateDto instance,
) => <String, dynamic>{
  'display_name': ?instance.display_name,
  'mother_language': ?instance.mother_language,
  'display_language': ?instance.display_language,
  'practice_goal_per_day': ?instance.practice_goal_per_day,
  'notification_time': ?instance.notification_time,
};
