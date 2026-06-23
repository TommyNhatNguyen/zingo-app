import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: true, createToJson: true)
class BaseError {
  final String code;
  final String type;
  final String detail;
  final String title;
  final int statusCode;
  final DateTime? timeStamp;
  final List<Map<String, dynamic>>? errors;

  BaseError({
    required this.code,
    required this.type,
    required this.detail,
    required this.title,
    required this.statusCode,
    required this.timeStamp,
    this.errors,
  });

  factory BaseError.fromJson(Map<String, dynamic> json) =>
      _$BaseErrorFromJson(json);
  Map<String, dynamic> toJson() => _$BaseErrorToJson(this);
}

@JsonSerializable(explicitToJson: true, createFactory: true, createToJson: true)
class ApiErrorResponse implements Exception {
  final bool success;
  final BaseError error;

  const ApiErrorResponse({this.success = false, required this.error});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorResponseToJson(this);
}
