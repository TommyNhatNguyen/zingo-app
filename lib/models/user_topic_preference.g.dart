// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_topic_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTopicPreference _$UserTopicPreferenceFromJson(Map<String, dynamic> json) =>
    UserTopicPreference(
      user_id: json['user_id'] as String,
      topic_normalize_name: json['topic_normalize_name'] as String,
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

Map<String, dynamic> _$UserTopicPreferenceToJson(
  UserTopicPreference instance,
) => <String, dynamic>{
  'user_id': instance.user_id,
  'topic_normalize_name': instance.topic_normalize_name,
  'created_at': instance.created_at?.toIso8601String(),
  'updated_at': instance.updated_at?.toIso8601String(),
  'deleted_at': instance.deleted_at?.toIso8601String(),
};
