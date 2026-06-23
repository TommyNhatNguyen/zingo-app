import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dialog_turns_by_dialog_id_payload.g.dart';

@JsonSerializable()
class DialogTurnsByDialogIdPayload extends Equatable {
  final String dialogId;

  const DialogTurnsByDialogIdPayload({
    this.dialogId = '13febbdf-a74c-4904-bc3b-c22bdec6a327',
  });

  factory DialogTurnsByDialogIdPayload.fromJson(Map<String, dynamic> json) =>
      _$DialogTurnsByDialogIdPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$DialogTurnsByDialogIdPayloadToJson(this);

  @override
  List<Object?> get props => [dialogId];
}
