import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dialog_progress.g.dart';

@JsonSerializable()
class UserDialogProgress extends Equatable {
  final String id;
  final String user_id;
  final String dialog_id;
  final double? best_score;
  final double? last_score;
  final int attempts;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const UserDialogProgress({
    required this.id,
    required this.user_id,
    required this.dialog_id,
    this.best_score,
    this.last_score,
    this.attempts = 0,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory UserDialogProgress.fromJson(Map<String, dynamic> json) =>
      _$UserDialogProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserDialogProgressToJson(this);

  @override
  List<Object?> get props => [
    id,
    user_id,
    dialog_id,
    best_score,
    last_score,
    attempts,
    created_at,
    updated_at,
    deleted_at,
  ];
}
