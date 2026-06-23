// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationsPayload _$RecommendationsPayloadFromJson(
  Map<String, dynamic> json,
) => RecommendationsPayload(
  user_id: json['user_id'] as String,
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 5,
);

Map<String, dynamic> _$RecommendationsPayloadToJson(
  RecommendationsPayload instance,
) => <String, dynamic>{
  'user_id': instance.user_id,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
