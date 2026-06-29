// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_configuration_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConfigurationUpdateDto _$UserConfigurationUpdateDtoFromJson(
  Map<String, dynamic> json,
) => UserConfigurationUpdateDto(
  profile: json['profile'] == null
      ? null
      : UserConfigurationProfileDto.fromJson(
          json['profile'] as Map<String, dynamic>,
        ),
  settings: json['settings'] == null
      ? null
      : UserConfigurationSettingsDto.fromJson(
          json['settings'] as Map<String, dynamic>,
        ),
  favorite_topics: (json['favorite_topics'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserConfigurationUpdateDtoToJson(
  UserConfigurationUpdateDto instance,
) => <String, dynamic>{
  'profile': ?instance.profile,
  'settings': ?instance.settings,
  'favorite_topics': ?instance.favorite_topics,
};

UserConfigurationProfileDto _$UserConfigurationProfileDtoFromJson(
  Map<String, dynamic> json,
) => UserConfigurationProfileDto(
  display_name: json['display_name'] as String?,
  mother_language: json['mother_language'] as String?,
);

Map<String, dynamic> _$UserConfigurationProfileDtoToJson(
  UserConfigurationProfileDto instance,
) => <String, dynamic>{
  'display_name': ?instance.display_name,
  'mother_language': ?instance.mother_language,
};

UserConfigurationSettingsDto _$UserConfigurationSettingsDtoFromJson(
  Map<String, dynamic> json,
) => UserConfigurationSettingsDto(
  practice_goal_per_day: (json['practice_goal_per_day'] as num?)?.toInt(),
  notification_time: json['notification_time'] as String?,
  display_language: json['display_language'] as String?,
);

Map<String, dynamic> _$UserConfigurationSettingsDtoToJson(
  UserConfigurationSettingsDto instance,
) => <String, dynamic>{
  'practice_goal_per_day': ?instance.practice_goal_per_day,
  'notification_time': ?instance.notification_time,
  'display_language': ?instance.display_language,
};
