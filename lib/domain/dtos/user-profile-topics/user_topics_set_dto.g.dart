// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_topics_set_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTopicsSetDto _$UserTopicsSetDtoFromJson(Map<String, dynamic> json) =>
    UserTopicsSetDto(
      topic_normalize_names: (json['topic_normalize_names'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserTopicsSetDtoToJson(UserTopicsSetDto instance) =>
    <String, dynamic>{'topic_normalize_names': instance.topic_normalize_names};
