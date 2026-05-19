// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_turn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialogTurn _$DialogTurnFromJson(Map<String, dynamic> json) => DialogTurn(
  id: json['id'] as String,
  dialog_id: json['dialog_id'] as String,
  turn_order: (json['turn_order'] as num).toInt(),
  speaker: json['speaker'] as String,
  line_text: json['line_text'] as String,
  context_note: json['context_note'] as String?,
  expected_answer: json['expected_answer'] as String?,
  tts_model_audio_url: json['tts_model_audio_url'] as String?,
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

Map<String, dynamic> _$DialogTurnToJson(DialogTurn instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dialog_id': instance.dialog_id,
      'turn_order': instance.turn_order,
      'speaker': instance.speaker,
      'line_text': instance.line_text,
      'context_note': instance.context_note,
      'expected_answer': instance.expected_answer,
      'tts_model_audio_url': instance.tts_model_audio_url,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
