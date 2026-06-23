import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/models/topic.dart';

part 'dialog.g.dart';


@JsonSerializable()
class Dialog extends Equatable {
  final String id;
  final String title;
  final String? thumbnail_url;
  final String? description;
  final String level;
  final String? cefr_level;
  final String duration;
  final int conversation_length;
  final int xp_points;
  final String? status;
  final String topic_id;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;
  final Topic? topics;
  final bool is_favorite;
  final String? practice_session_id;
  final DialogProgress? progress;

  const Dialog({
    required this.id,
    required this.title,
    this.thumbnail_url,
    this.description,
    required this.level,
    this.cefr_level,
    required this.duration,
    required this.conversation_length,
    required this.xp_points,
    this.status,
    required this.topic_id,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.topics,
    this.is_favorite = false,
    this.practice_session_id,
    this.progress,
  });

  factory Dialog.fromJson(Map<String, dynamic> json) => _$DialogFromJson(json);

  Map<String, dynamic> toJson() => _$DialogToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    thumbnail_url,
    description,
    level,
    cefr_level,
    duration,
    conversation_length,
    xp_points,
    status,
    topic_id,
    created_at,
    updated_at,
    deleted_at,
    topics,
    is_favorite,
    practice_session_id,
    progress,
  ];
}

@JsonSerializable()
class DialogProgress extends Equatable {
  final double highest_score;
  final double latest_score;
  final int attempts;

  const DialogProgress({
    required this.highest_score,
    required this.latest_score,
    required this.attempts,
  });

  factory DialogProgress.fromJson(Map<String, dynamic> json) =>
      _$DialogProgressFromJson(json);

  Map<String, dynamic> toJson() => _$DialogProgressToJson(this);

  @override
  List<Object?> get props => [highest_score, latest_score, attempts];
}
