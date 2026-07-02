import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/core/constants/enums.dart';

part 'user_profile_create_dto.g.dart';

@JsonSerializable()
class UserProfileCreateDto extends Equatable {
  final String user_id;
  final EnglishLevel cefr_level;
  final String display_name;
  final String mother_language;
  final String display_language;
  final int? practice_goal_per_day;
  final String? notification_time;
  final String? timezone;
  final List<String>? favorite_topics;

  const UserProfileCreateDto({
    required this.user_id,
    required this.cefr_level,
    required this.display_name,
    required this.mother_language,
    required this.display_language,
    this.practice_goal_per_day,
    this.notification_time,
    this.timezone,
    this.favorite_topics,
  });

  factory UserProfileCreateDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileCreateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileCreateDtoToJson(this);

  @override
  List<Object?> get props => [
    user_id,
    cefr_level,
    display_name,
    mother_language,
    display_language,
    practice_goal_per_day,
    notification_time,
    timezone,
    favorite_topics,
  ];
}
