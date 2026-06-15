import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  final String user_id;
  final String? display_name;
  final String? mother_language;
  final String? display_language;
  final int? practice_goal_per_day;
  final String? notification_time;
  final String cefr_level;
  final String level;
  final int xp;
  final int streak;
  final int longest_streak;
  final DateTime? last_practice_at;
  final Map<String, bool>? currentWeekStreak;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const UserProfile({
    required this.cefr_level,
    required this.level,
    required this.xp,
    required this.streak,
    required this.longest_streak,
    this.last_practice_at,
    this.currentWeekStreak,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    required this.user_id,
    this.display_name,
    this.mother_language,
    this.display_language,
    this.practice_goal_per_day,
    this.notification_time,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  List<Object?> get props => [
    cefr_level,
    level,
    xp,
    streak,
    longest_streak,
    last_practice_at,
    currentWeekStreak,
    created_at,
    updated_at,
    deleted_at,
    user_id,
    display_name,
    mother_language,
    display_language,
    practice_goal_per_day,
    notification_time,
  ];
}
