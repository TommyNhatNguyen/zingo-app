import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dialog_list_payload.g.dart';

@JsonSerializable()
class DialogListPayload extends Equatable {
  final int page;
  final int limit;

  const DialogListPayload({this.page = 1, this.limit = 10});

  factory DialogListPayload.fromJson(Map<String, dynamic> json) =>
      _$DialogListPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$DialogListPayloadToJson(this);

  @override
  List<Object?> get props => [page, limit];
}
