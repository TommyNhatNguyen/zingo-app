import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_settings_update_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class UserSettingsUpdateDto extends Equatable {
  final int? practice_goal_per_day;
  final String? notification_time;
  final String? display_language;

  const UserSettingsUpdateDto({
    this.practice_goal_per_day,
    this.notification_time,
    this.display_language,
  });

  UserSettingsUpdateDto copyWith({
    int? practice_goal_per_day,
    String? notification_time,
    String? display_language,
  }) => UserSettingsUpdateDto(
    practice_goal_per_day: practice_goal_per_day ?? this.practice_goal_per_day,
    notification_time: notification_time ?? this.notification_time,
    display_language: display_language ?? this.display_language,
  );

  factory UserSettingsUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsUpdateDtoToJson(this);

  @override
  List<Object?> get props => [
    practice_goal_per_day,
    notification_time,
    display_language,
  ];
}
