// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseError _$BaseErrorFromJson(Map<String, dynamic> json) => BaseError(
  code: json['code'] as String,
  type: json['type'] as String,
  detail: json['detail'] as String,
  title: json['title'] as String,
  statusCode: (json['statusCode'] as num).toInt(),
  timeStamp: json['timeStamp'] == null
      ? null
      : DateTime.parse(json['timeStamp'] as String),
  errors: (json['errors'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$BaseErrorToJson(BaseError instance) => <String, dynamic>{
  'code': instance.code,
  'type': instance.type,
  'detail': instance.detail,
  'title': instance.title,
  'statusCode': instance.statusCode,
  'timeStamp': instance.timeStamp?.toIso8601String(),
  'errors': instance.errors,
};

ApiErrorResponse _$ApiErrorResponseFromJson(Map<String, dynamic> json) =>
    ApiErrorResponse(
      success: json['success'] as bool? ?? false,
      error: BaseError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiErrorResponseToJson(ApiErrorResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error.toJson(),
    };
