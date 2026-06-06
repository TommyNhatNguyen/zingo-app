import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/practice_session.dart';

part 'completed_practice_session.g.dart';

@JsonSerializable()
class CompletedPracticeSession extends PracticeSession {
  final int xp;
  final Map<String, bool> currentWeekStreak;
  final int streak;

  const CompletedPracticeSession({
    required super.id,
    required super.user_id,
    required super.dialog_id,
    required super.practice_mode,
    super.started_at,
    super.completed_at,
    super.not_completed_reason,
    super.current_turn_order,
    super.holistic_score,
    super.holistic_feedback,
    super.grammar_avg_score,
    super.naturalness_avg_score,
    super.completeness_avg_score,
    super.created_at,
    super.updated_at,
    super.deleted_at,
    required this.xp,
    required this.currentWeekStreak,
    required this.streak,
  });

  factory CompletedPracticeSession.fromJson(Map<String, dynamic> json) =>
      _$CompletedPracticeSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CompletedPracticeSessionToJson(this);

  @override
  List<Object?> get props => [...super.props, xp, currentWeekStreak, streak];
}
