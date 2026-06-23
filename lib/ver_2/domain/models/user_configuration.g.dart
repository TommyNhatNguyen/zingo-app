// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConfiguration _$UserConfigurationFromJson(Map<String, dynamic> json) =>
    UserConfiguration(
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : UserSetting.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserConfigurationToJson(UserConfiguration instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'settings': instance.settings,
    };
