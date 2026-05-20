import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dialog_detail_payload.g.dart';

@JsonSerializable()
class DialogDetailPayload extends Equatable {
  final String id;

  const DialogDetailPayload({required this.id});

  factory DialogDetailPayload.fromJson(Map<String, dynamic> json) =>
      _$DialogDetailPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$DialogDetailPayloadToJson(this);

  @override
  List<Object?> get props => [id];
}
