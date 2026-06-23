// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_turn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionTurn _$SessionTurnFromJson(Map<String, dynamic> json) => SessionTurn(
  id: json['id'] as String,
  session_id: json['session_id'] as String,
  dialog_turn_id: json['dialog_turn_id'] as String,
  answer_text: json['answer_text'] as String,
  passed: json['passed'] as bool,
  pass_threshold: (json['pass_threshold'] as num?)?.toDouble() ?? 0.4,
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

Map<String, dynamic> _$SessionTurnToJson(SessionTurn instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.session_id,
      'dialog_turn_id': instance.dialog_turn_id,
      'answer_text': instance.answer_text,
      'passed': instance.passed,
      'pass_threshold': instance.pass_threshold,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
