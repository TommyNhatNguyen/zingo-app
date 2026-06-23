import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'suggestion_dialog.g.dart';

@JsonSerializable()
class SuggestionDialog extends Equatable {
  final String id;
  final String suggestion_id;
  final String chapter_id;
  final int order_index;
  final String dialog_id;
  final String status; // "waiting" | "in_progress" | "completed"
  final DateTime? completed_at;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const SuggestionDialog({
    required this.id,
    required this.suggestion_id,
    required this.chapter_id,
    required this.order_index,
    required this.dialog_id,
    this.status = 'waiting',
    this.completed_at,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory SuggestionDialog.fromJson(Map<String, dynamic> json) =>
      _$SuggestionDialogFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionDialogToJson(this);

  @override
  List<Object?> get props => [
    id,
    suggestion_id,
    chapter_id,
    order_index,
    dialog_id,
    status,
    completed_at,
    created_at,
    updated_at,
    deleted_at,
  ];
}
