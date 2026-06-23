// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_streak_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserStreakPayload _$GetUserStreakPayloadFromJson(
  Map<String, dynamic> json,
) => GetUserStreakPayload(
  user_id: json['user_id'] as String,
  year: (json['year'] as num).toInt(),
);

Map<String, dynamic> _$GetUserStreakPayloadToJson(
  GetUserStreakPayload instance,
) => <String, dynamic>{'user_id': instance.user_id, 'year': instance.year};
