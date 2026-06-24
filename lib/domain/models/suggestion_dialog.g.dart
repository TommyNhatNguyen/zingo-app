// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_dialog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestionDialog _$SuggestionDialogFromJson(Map<String, dynamic> json) =>
    SuggestionDialog(
      id: json['id'] as String,
      suggestion_id: json['suggestion_id'] as String,
      chapter_id: json['chapter_id'] as String,
      order_index: (json['order_index'] as num).toInt(),
      dialog_id: json['dialog_id'] as String,
      status: json['status'] as String? ?? 'waiting',
      completed_at: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
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

Map<String, dynamic> _$SuggestionDialogToJson(SuggestionDialog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'suggestion_id': instance.suggestion_id,
      'chapter_id': instance.chapter_id,
      'order_index': instance.order_index,
      'dialog_id': instance.dialog_id,
      'status': instance.status,
      'completed_at': instance.completed_at?.toIso8601String(),
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
