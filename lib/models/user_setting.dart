import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_setting.g.dart';

@JsonSerializable()
class UserSetting extends Equatable {
  final String user_id;
  final int? practice_goal_per_day;
  final String? notification_time;
  final String? display_language;

  const UserSetting({
    required this.user_id,
    this.practice_goal_per_day,
    this.notification_time,
    this.display_language,
  });

  factory UserSetting.fromJson(Map<String, dynamic> json) =>
      _$UserSettingFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingToJson(this);

  @override
  List<Object?> get props => [
    user_id,
    practice_goal_per_day,
    notification_time,
    display_language,
  ];
}
