import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_favorite_dialogs_payload.g.dart';

@JsonSerializable()
class ListFavoriteDialogsPayload extends Equatable {
  final String? userId;
  final int page;
  final int limit;

  const ListFavoriteDialogsPayload({
    this.userId,
    this.page = 1,
    this.limit = 10,
  });

  factory ListFavoriteDialogsPayload.fromJson(Map<String, dynamic> json) =>
      _$ListFavoriteDialogsPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$ListFavoriteDialogsPayloadToJson(this);

  ListFavoriteDialogsPayload copyWith({
    String? userId,
    int? page,
    int? limit,
  }) {
    return ListFavoriteDialogsPayload(
      userId: userId ?? this.userId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [userId, page, limit];
}
