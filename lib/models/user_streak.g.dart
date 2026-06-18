// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStreak _$UserStreakFromJson(Map<String, dynamic> json) => UserStreak(
  user_id: json['user_id'] as String,
  year: (json['year'] as num).toInt(),
  streak_bitmap: json['streak_bitmap'] as String,
  streak_dates: (json['streak_dates'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
  created_at: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updated_at: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deleted_at: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$UserStreakToJson(UserStreak instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'year': instance.year,
      'streak_bitmap': instance.streak_bitmap,
      'streak_dates': instance.streak_dates,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
