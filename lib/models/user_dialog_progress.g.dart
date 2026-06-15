// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dialog_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDialogProgress _$UserDialogProgressFromJson(Map<String, dynamic> json) =>
    UserDialogProgress(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      dialog_id: json['dialog_id'] as String,
      best_score: (json['best_score'] as num?)?.toDouble(),
      last_score: (json['last_score'] as num?)?.toDouble(),
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
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

Map<String, dynamic> _$UserDialogProgressToJson(UserDialogProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'dialog_id': instance.dialog_id,
      'best_score': instance.best_score,
      'last_score': instance.last_score,
      'attempts': instance.attempts,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
