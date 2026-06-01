import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_favorite_dialogs_payload.g.dart';

@JsonSerializable()
class ListFavoriteDialogsPayload extends Equatable {
  final String? userId;

  const ListFavoriteDialogsPayload({this.userId});

  factory ListFavoriteDialogsPayload.fromJson(Map<String, dynamic> json) =>
      _$ListFavoriteDialogsPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$ListFavoriteDialogsPayloadToJson(this);

  @override
  List<Object?> get props => [userId];
}
