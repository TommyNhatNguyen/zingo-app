// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersUpdateDto _$UsersUpdateDtoFromJson(Map<String, dynamic> json) =>
    UsersUpdateDto(
      cefr_level: $enumDecodeNullable(
        _$EnglishLevelEnumMap,
        json['cefr_level'],
      ),
    );

Map<String, dynamic> _$UsersUpdateDtoToJson(UsersUpdateDto instance) =>
    <String, dynamic>{
      'cefr_level': ?_$EnglishLevelEnumMap[instance.cefr_level],
    };

const _$EnglishLevelEnumMap = {
  EnglishLevel.A1: 'A1',
  EnglishLevel.A2: 'A2',
  EnglishLevel.B1: 'B1',
  EnglishLevel.B2: 'B2',
  EnglishLevel.C1: 'C1',
  EnglishLevel.C2: 'C2',
};
