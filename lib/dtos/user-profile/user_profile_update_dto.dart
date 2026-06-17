import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_update_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class UserProfileUpdateDto extends Equatable {
  final String? display_name;
  final String? mother_language;

  const UserProfileUpdateDto({this.display_name, this.mother_language});

  UserProfileUpdateDto copyWith({
    String? display_name,
    String? mother_language,
  }) => UserProfileUpdateDto(
    display_name: display_name ?? this.display_name,
    mother_language: mother_language ?? this.mother_language,
  );

  factory UserProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileUpdateDtoToJson(this);

  @override
  List<Object?> get props => [display_name, mother_language];
}
