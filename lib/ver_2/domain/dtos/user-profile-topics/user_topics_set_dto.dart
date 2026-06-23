import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_topics_set_dto.g.dart';

@JsonSerializable()
class UserTopicsSetDto extends Equatable {
  final List<String> topic_normalize_names;

  const UserTopicsSetDto({required this.topic_normalize_names});

  factory UserTopicsSetDto.fromJson(Map<String, dynamic> json) =>
      _$UserTopicsSetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserTopicsSetDtoToJson(this);

  @override
  List<Object?> get props => [topic_normalize_names];
}
