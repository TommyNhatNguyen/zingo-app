// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSuggestion _$UserSuggestionFromJson(Map<String, dynamic> json) =>
    UserSuggestion(
      id: json['id'] as String,
      suggestion_id: json['suggestion_id'] as String,
      user_id: json['user_id'] as String,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$UserSuggestionToJson(UserSuggestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'suggestion_id': instance.suggestion_id,
      'user_id': instance.user_id,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
