import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/core/constants/enums.dart';

part 'dialog_turn.g.dart';

@JsonSerializable()
class DialogTurn extends Equatable {
  final String id;
  final String dialog_id;
  final int turn_order;
  final Speaker speaker;
  final String line_text;
  final String? context_note;
  final String? expected_answer;
  final String? tts_model_audio_url;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const DialogTurn({
    required this.id,
    required this.dialog_id,
    required this.turn_order,
    required this.speaker,
    required this.line_text,
    this.context_note,
    this.expected_answer,
    this.tts_model_audio_url,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory DialogTurn.fromJson(Map<String, dynamic> json) =>
      _$DialogTurnFromJson(json);

  Map<String, dynamic> toJson() => _$DialogTurnToJson(this);

  @override
  List<Object?> get props => [
    id,
    dialog_id,
    turn_order,
    speaker,
    line_text,
    context_note,
    expected_answer,
    tts_model_audio_url,
    created_at,
    updated_at,
    deleted_at,
  ];
}
