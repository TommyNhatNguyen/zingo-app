import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/models/practice_session.dart';
import 'package:zingo/domain/models/user_streak.dart';

part 'completed_practice_session.g.dart';

@JsonSerializable()
class CompletedPracticeSession extends PracticeSession {
  final int xp;
  final int streak;
  @JsonKey(name: 'userStreak')
  final UserStreak? user_streak;

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
    required this.streak,
    this.user_streak,
  });

  factory CompletedPracticeSession.fromJson(Map<String, dynamic> json) =>
      _$CompletedPracticeSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CompletedPracticeSessionToJson(this);

  @override
  List<Object?> get props => [...super.props, xp, streak, user_streak];
}
