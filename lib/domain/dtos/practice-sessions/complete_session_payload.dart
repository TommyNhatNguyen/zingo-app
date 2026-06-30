import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complete_session_payload.g.dart';

@JsonSerializable()
class SessionAnswer extends Equatable {
  final int turn_order;
  final String answer_text;
  final bool passed;
  final double pass_threshold;

  const SessionAnswer({
    required this.turn_order,
    required this.answer_text,
    this.passed = false,
    this.pass_threshold = 0.4,
  });

  factory SessionAnswer.fromJson(Map<String, dynamic> json) =>
      _$SessionAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$SessionAnswerToJson(this);

  @override
  List<Object?> get props => [turn_order, answer_text, passed, pass_threshold];
}

@JsonSerializable()
class CompleteSessionPayload extends Equatable {
  final String id;
  final List<SessionAnswer> answers;
  final String? not_completed_reason;
  final int? current_turn_order;
  final String? suggestion_dialog_id;

  const CompleteSessionPayload({
    required this.id,
    required this.answers,
    this.not_completed_reason,
    this.current_turn_order,
    this.suggestion_dialog_id,
  });

  factory CompleteSessionPayload.fromJson(Map<String, dynamic> json) =>
      _$CompleteSessionPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteSessionPayloadToJson(this);

  @override
  List<Object?> get props => [
    id,
    answers,
    not_completed_reason,
    current_turn_order,
    suggestion_dialog_id,
  ];
}
