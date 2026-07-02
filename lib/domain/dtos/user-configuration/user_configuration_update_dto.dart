import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_configuration_update_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class UserConfigurationUpdateDto extends Equatable {
  final UserConfigurationProfileDto? profile;
  final UserConfigurationSettingsDto? settings;
  final List<String>? favorite_topics;

  const UserConfigurationUpdateDto({
    this.profile,
    this.settings,
    this.favorite_topics,
  });

  factory UserConfigurationUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigurationUpdateDtoToJson(this);

  @override
  List<Object?> get props => [profile, settings, favorite_topics];
}

@JsonSerializable(includeIfNull: false)
class UserConfigurationProfileDto extends Equatable {
  final String? display_name;
  final String? mother_language;
  final String? timezone;

  const UserConfigurationProfileDto({
    this.display_name,
    this.mother_language,
    this.timezone,
  });

  factory UserConfigurationProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigurationProfileDtoToJson(this);

  @override
  List<Object?> get props => [display_name, mother_language, timezone];
}

@JsonSerializable(includeIfNull: false)
class UserConfigurationSettingsDto extends Equatable {
  final int? practice_goal_per_day;
  final String? notification_time;
  final String? display_language;

  const UserConfigurationSettingsDto({
    this.practice_goal_per_day,
    this.notification_time,
    this.display_language,
  });

  factory UserConfigurationSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationSettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserConfigurationSettingsDtoToJson(this);

  @override
  List<Object?> get props => [
    practice_goal_per_day,
    notification_time,
    display_language,
  ];
}
