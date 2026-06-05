import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/constants/enums.dart';

part 'practice_session.g.dart';

@JsonSerializable()
class PracticeSession extends Equatable {
  final String id;
  final String user_id;
  final String dialog_id;
  final PracticeMode practice_mode;
  final DateTime? started_at;
  final DateTime? completed_at;
  final String? not_completed_reason;
  final int current_turn_order;
  final double? holistic_score;
  final String? holistic_feedback;
  final double? grammar_avg_score;
  final double? naturalness_avg_score;
  final double? completeness_avg_score;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const PracticeSession({
    required this.id,
    required this.user_id,
    required this.dialog_id,
    required this.practice_mode,
    this.started_at,
    this.completed_at,
    this.not_completed_reason,
    this.current_turn_order = 1,
    this.holistic_score,
    this.holistic_feedback,
    this.grammar_avg_score,
    this.naturalness_avg_score,
    this.completeness_avg_score,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory PracticeSession.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PracticeSessionToJson(this);

  @override
  List<Object?> get props => [
    id,
    user_id,
    dialog_id,
    practice_mode,
    started_at,
    completed_at,
    not_completed_reason,
    current_turn_order,
    holistic_score,
    holistic_feedback,
    grammar_avg_score,
    naturalness_avg_score,
    completeness_avg_score,
    created_at,
    updated_at,
    deleted_at,
  ];
}
