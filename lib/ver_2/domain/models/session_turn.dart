import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_turn.g.dart';

@JsonSerializable()
class SessionTurn extends Equatable {
  final String id;
  final String session_id;
  final String dialog_turn_id;
  final String answer_text;
  final bool passed;
  final double pass_threshold;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const SessionTurn({
    required this.id,
    required this.session_id,
    required this.dialog_turn_id,
    required this.answer_text,
    required this.passed,
    this.pass_threshold = 0.4,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory SessionTurn.fromJson(Map<String, dynamic> json) =>
      _$SessionTurnFromJson(json);

  Map<String, dynamic> toJson() => _$SessionTurnToJson(this);

  @override
  List<Object?> get props => [
    id,
    session_id,
    dialog_turn_id,
    answer_text,
    passed,
    pass_threshold,
    created_at,
    updated_at,
    deleted_at,
  ];
}
