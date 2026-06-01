import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_active_dialogs_payload.g.dart';

@JsonSerializable()
class ListActiveDialogsPayload extends Equatable {
  final String? userId;

  const ListActiveDialogsPayload({this.userId});

  factory ListActiveDialogsPayload.fromJson(Map<String, dynamic> json) =>
      _$ListActiveDialogsPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$ListActiveDialogsPayloadToJson(this);

  @override
  List<Object?> get props => [userId];
}
