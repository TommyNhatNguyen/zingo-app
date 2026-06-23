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

DialogListPayload _$DialogListPayloadFromJson(Map<String, dynamic> json) =>
    DialogListPayload(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      orderBy: (json['orderBy'] as List<dynamic>?)
          ?.map((e) => OrderByItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DialogListPayloadToJson(DialogListPayload instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'orderBy': instance.orderBy?.map((e) => e.toJson()).toList(),
    };
