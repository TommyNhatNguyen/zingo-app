// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_favorite_dialogs_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListFavoriteDialogsPayload _$ListFavoriteDialogsPayloadFromJson(
  Map<String, dynamic> json,
) => ListFavoriteDialogsPayload(
  userId: json['userId'] as String?,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$ListFavoriteDialogsPayloadToJson(
  ListFavoriteDialogsPayload instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'page': instance.page,
  'limit': instance.limit,
};
