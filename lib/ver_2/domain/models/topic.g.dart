// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
  normalize_name: json['normalize_name'] as String,
  name: json['name'] as String,
  thumbnail_url: json['thumbnail_url'] as String?,
  icon_url: json['icon_url'] as String?,
  emoji: json['emoji'] as String?,
  parent_topic_normalize_name: json['parent_topic_normalize_name'] as String?,
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

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
  'normalize_name': instance.normalize_name,
  'name': instance.name,
  'thumbnail_url': instance.thumbnail_url,
  'icon_url': instance.icon_url,
  'emoji': instance.emoji,
  'parent_topic_normalize_name': instance.parent_topic_normalize_name,
  'created_at': instance.created_at?.toIso8601String(),
  'updated_at': instance.updated_at?.toIso8601String(),
  'deleted_at': instance.deleted_at?.toIso8601String(),
};
