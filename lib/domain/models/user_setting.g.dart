// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSetting _$UserSettingFromJson(Map<String, dynamic> json) => UserSetting(
  user_id: json['user_id'] as String,
  practice_goal_per_day: (json['practice_goal_per_day'] as num?)?.toInt(),
  notification_time: json['notification_time'] as String?,
  display_language: json['display_language'] as String?,
);

Map<String, dynamic> _$UserSettingToJson(UserSetting instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'practice_goal_per_day': instance.practice_goal_per_day,
      'notification_time': instance.notification_time,
      'display_language': instance.display_language,
    };
