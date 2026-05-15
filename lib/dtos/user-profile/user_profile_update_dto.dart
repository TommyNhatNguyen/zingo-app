import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_update_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class UserProfileUpdateDto extends Equatable {
  final String? display_name;
  final String? mother_language;
  final String? display_language;
  final int? practice_goal_per_day;
  final String? notification_time;

  const UserProfileUpdateDto({
    this.display_name,
    this.mother_language,
    this.display_language,
    this.practice_goal_per_day,
    this.notification_time,
  });

  factory UserProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileUpdateDtoToJson(this);

  @override
  List<Object?> get props => [
    display_name,
    mother_language,
    display_language,
    practice_goal_per_day,
    notification_time,
  ];
}
