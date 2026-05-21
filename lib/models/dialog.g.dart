// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dialog _$DialogFromJson(Map<String, dynamic> json) => Dialog(
  id: json['id'] as String,
  title: json['title'] as String,
  thumbnail_url: json['thumbnail_url'] as String?,
  description: json['description'] as String?,
  level: json['level'] as String,
  cefr_level: json['cefr_level'] as String?,
  duration: json['duration'] as String,
  conversation_length: (json['conversation_length'] as num).toInt(),
  xp_points: (json['xp_points'] as num).toInt(),
  status: json['status'] as String?,
  topic_id: json['topic_id'] as String,
  created_at: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updated_at: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  deleted_at: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  topics: json['topics'] == null
      ? null
      : Topic.fromJson(json['topics'] as Map<String, dynamic>),
  is_favorite: json['is_favorite'] as bool? ?? false,
);

Map<String, dynamic> _$DialogToJson(Dialog instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'thumbnail_url': instance.thumbnail_url,
  'description': instance.description,
  'level': instance.level,
  'cefr_level': instance.cefr_level,
  'duration': instance.duration,
  'conversation_length': instance.conversation_length,
  'xp_points': instance.xp_points,
  'status': instance.status,
  'topic_id': instance.topic_id,
  'created_at': instance.created_at?.toIso8601String(),
  'updated_at': instance.updated_at?.toIso8601String(),
  'deleted_at': instance.deleted_at?.toIso8601String(),
  'topics': instance.topics,
  'is_favorite': instance.is_favorite,
};
