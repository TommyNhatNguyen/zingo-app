import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_year_streak.g.dart';

@JsonSerializable()
class UserYearStreak extends Equatable {
  final String user_id;
  final int year;
  final String streak_bitmap;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const UserYearStreak({
    required this.user_id,
    required this.year,
    required this.streak_bitmap,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory UserYearStreak.fromJson(Map<String, dynamic> json) =>
      _$UserYearStreakFromJson(json);

  Map<String, dynamic> toJson() => _$UserYearStreakToJson(this);

  @override
  List<Object?> get props => [
    user_id,
    year,
    streak_bitmap,
    created_at,
    updated_at,
    deleted_at,
  ];
}
