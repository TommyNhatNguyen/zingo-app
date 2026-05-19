// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_list_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialogListPayload _$DialogListPayloadFromJson(Map<String, dynamic> json) =>
    DialogListPayload(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$DialogListPayloadToJson(DialogListPayload instance) =>
    <String, dynamic>{'page': instance.page, 'limit': instance.limit};
