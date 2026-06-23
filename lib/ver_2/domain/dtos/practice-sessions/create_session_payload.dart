import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_session_payload.g.dart';

@JsonSerializable()
class CreateSessionPayload extends Equatable {
  final String user_id;
  final String dialog_id;
  final String practice_mode;

  const CreateSessionPayload({
    required this.user_id,
    required this.dialog_id,
    this.practice_mode = 'read_aloud',
  });

  factory CreateSessionPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$CreateSessionPayloadToJson(this);

  @override
  List<Object?> get props => [user_id, dialog_id, practice_mode];
}
