import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_streak.g.dart';

@JsonSerializable()
class UserStreak extends Equatable {
  final String user_id;
  final int year;
  final String streak_bitmap;
  final Map<String, bool>? streak_dates;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const UserStreak({
    required this.user_id,
    required this.year,
    required this.streak_bitmap,
    this.streak_dates,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory UserStreak.fromJson(Map<String, dynamic> json) =>
      _$UserStreakFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreakToJson(this);

  @override
  List<Object?> get props => [
    user_id,
    year,
    streak_bitmap,
    streak_dates,
    created_at,
    updated_at,
    deleted_at,
  ];
}
