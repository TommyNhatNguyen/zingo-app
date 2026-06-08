// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_practice_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedPracticeSession _$CompletedPracticeSessionFromJson(
  Map<String, dynamic> json,
) => CompletedPracticeSession(
  id: json['id'] as String,
  user_id: json['user_id'] as String,
  dialog_id: json['dialog_id'] as String,
  practice_mode: $enumDecode(_$PracticeModeEnumMap, json['practice_mode']),
  started_at: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  completed_at: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  not_completed_reason: json['not_completed_reason'] as String?,
  current_turn_order: (json['current_turn_order'] as num?)?.toInt() ?? 1,
  holistic_score: (json['holistic_score'] as num?)?.toDouble(),
  holistic_feedback: json['holistic_feedback'] as String?,
  grammar_avg_score: (json['grammar_avg_score'] as num?)?.toDouble(),
  naturalness_avg_score: (json['naturalness_avg_score'] as num?)?.toDouble(),
  completeness_avg_score: (json['completeness_avg_score'] as num?)?.toDouble(),
  created_at: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updated_at: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deleted_at: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  xp: (json['xp'] as num).toInt(),
  currentWeekStreak: Map<String, bool>.from(json['currentWeekStreak'] as Map),
  streak: (json['streak'] as num).toInt(),
);

Map<String, dynamic> _$CompletedPracticeSessionToJson(
  CompletedPracticeSession instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.user_id,
  'dialog_id': instance.dialog_id,
  'practice_mode': _$PracticeModeEnumMap[instance.practice_mode]!,
  'started_at': instance.started_at?.toIso8601String(),
  'completed_at': instance.completed_at?.toIso8601String(),
  'not_completed_reason': instance.not_completed_reason,
  'current_turn_order': instance.current_turn_order,
  'holistic_score': instance.holistic_score,
  'holistic_feedback': instance.holistic_feedback,
  'grammar_avg_score': instance.grammar_avg_score,
  'naturalness_avg_score': instance.naturalness_avg_score,
  'completeness_avg_score': instance.completeness_avg_score,
  'created_at': instance.created_at?.toIso8601String(),
  'updated_at': instance.updated_at?.toIso8601String(),
  'deleted_at': instance.deleted_at?.toIso8601String(),
  'xp': instance.xp,
  'currentWeekStreak': instance.currentWeekStreak,
  'streak': instance.streak,
};

const _$PracticeModeEnumMap = {
  PracticeMode.freeSpeak: 'free_speak',
  PracticeMode.readAloud: 'read_aloud',
};
