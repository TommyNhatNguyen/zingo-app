// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_list_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderByItem _$OrderByItemFromJson(Map<String, dynamic> json) => OrderByItem(
  column: json['column'] as String,
  direction: json['direction'] as String? ?? 'asc',
);

Map<String, dynamic> _$OrderByItemToJson(OrderByItem instance) =>
    <String, dynamic>{
      'column': instance.column,
      'direction': instance.direction,
    };

DialogListQuery _$DialogListQueryFromJson(Map<String, dynamic> json) =>
    DialogListQuery(
      durations: (json['durations'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DialogDurationEnumMap, e))
          .toList(),
      cefrLevels: (json['cefr_levels'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EnglishLevelEnumMap, e))
          .toList(),
      topicIds: (json['topic_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DialogListQueryToJson(DialogListQuery instance) =>
    <String, dynamic>{
      'durations': ?instance.durations
          ?.map((e) => _$DialogDurationEnumMap[e]!)
          .toList(),
      'cefr_levels': ?instance.cefrLevels
          ?.map((e) => _$EnglishLevelEnumMap[e]!)
          .toList(),
      'topic_ids': ?instance.topicIds,
    };

const _$DialogDurationEnumMap = {
  DialogDuration.short: 'short',
  DialogDuration.mid: 'mid',
  DialogDuration.long: 'long',
};

const _$EnglishLevelEnumMap = {
  EnglishLevel.A1: 'A1',
  EnglishLevel.A2: 'A2',
  EnglishLevel.B1: 'B1',
  EnglishLevel.B2: 'B2',
  EnglishLevel.C1: 'C1',
  EnglishLevel.C2: 'C2',
};

DialogListPayload _$DialogListPayloadFromJson(Map<String, dynamic> json) =>
    DialogListPayload(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      orderBy: (json['orderBy'] as List<dynamic>?)
          ?.map((e) => OrderByItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      query: json['query'] == null
          ? null
          : DialogListQuery.fromJson(json['query'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DialogListPayloadToJson(DialogListPayload instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'orderBy': ?instance.orderBy?.map((e) => e.toJson()).toList(),
      'query': ?instance.query?.toJson(),
    };
