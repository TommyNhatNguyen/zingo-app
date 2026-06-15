// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dialog_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDialogFavorite _$UserDialogFavoriteFromJson(Map<String, dynamic> json) =>
    UserDialogFavorite(
      user_id: json['user_id'] as String,
      dialog_id: json['dialog_id'] as String,
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

Map<String, dynamic> _$UserDialogFavoriteToJson(UserDialogFavorite instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'dialog_id': instance.dialog_id,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
