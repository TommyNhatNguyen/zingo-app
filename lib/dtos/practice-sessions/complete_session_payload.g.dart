// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_session_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionAnswer _$SessionAnswerFromJson(Map<String, dynamic> json) =>
    SessionAnswer(
      turn_order: (json['turn_order'] as num).toInt(),
      answer_text: json['answer_text'] as String,
      passed: json['passed'] as bool? ?? false,
      pass_threshold: (json['pass_threshold'] as num?)?.toDouble() ?? 0.4,
    );

Map<String, dynamic> _$SessionAnswerToJson(SessionAnswer instance) =>
    <String, dynamic>{
      'turn_order': instance.turn_order,
      'answer_text': instance.answer_text,
      'passed': instance.passed,
      'pass_threshold': instance.pass_threshold,
    };

CompleteSessionPayload _$CompleteSessionPayloadFromJson(
  Map<String, dynamic> json,
) => CompleteSessionPayload(
  id: json['id'] as String,
  answers: (json['answers'] as List<dynamic>)
      .map((e) => SessionAnswer.fromJson(e as Map<String, dynamic>))
      .toList(),
  not_completed_reason: json['not_completed_reason'] as String?,
  current_turn_order: (json['current_turn_order'] as num?)?.toInt(),
);

Map<String, dynamic> _$CompleteSessionPayloadToJson(
  CompleteSessionPayload instance,
) => <String, dynamic>{
  'id': instance.id,
  'answers': instance.answers.map((e) => e.toJson()).toList(),
  'not_completed_reason': instance.not_completed_reason,
  'current_turn_order': instance.current_turn_order,
};
