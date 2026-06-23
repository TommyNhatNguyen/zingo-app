// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSessionPayload _$CreateSessionPayloadFromJson(
  Map<String, dynamic> json,
) => CreateSessionPayload(
  user_id: json['user_id'] as String,
  dialog_id: json['dialog_id'] as String,
  practice_mode: json['practice_mode'] as String? ?? 'read_aloud',
);

Map<String, dynamic> _$CreateSessionPayloadToJson(
  CreateSessionPayload instance,
) => <String, dynamic>{
  'user_id': instance.user_id,
  'dialog_id': instance.dialog_id,
  'practice_mode': instance.practice_mode,
};
