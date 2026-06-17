// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingsUpdateDto _$UserSettingsUpdateDtoFromJson(
  Map<String, dynamic> json,
) => UserSettingsUpdateDto(
  practice_goal_per_day: (json['practice_goal_per_day'] as num?)?.toInt(),
  notification_time: json['notification_time'] as String?,
  display_language: json['display_language'] as String?,
);

Map<String, dynamic> _$UserSettingsUpdateDtoToJson(
  UserSettingsUpdateDto instance,
) => <String, dynamic>{
  'practice_goal_per_day': ?instance.practice_goal_per_day,
  'notification_time': ?instance.notification_time,
  'display_language': ?instance.display_language,
};
