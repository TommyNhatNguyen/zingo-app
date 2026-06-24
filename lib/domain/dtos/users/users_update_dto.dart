import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/core/constants/enums.dart';

part 'users_update_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class UsersUpdateDto extends Equatable {
  final EnglishLevel? cefr_level;

  const UsersUpdateDto({this.cefr_level});

  factory UsersUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UsersUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UsersUpdateDtoToJson(this);

  @override
  List<Object?> get props => [cefr_level];
}
