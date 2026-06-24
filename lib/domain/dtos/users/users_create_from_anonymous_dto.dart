import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_create_from_anonymous_dto.g.dart';

@JsonSerializable()
class UsersCreateFromAnonymousDto extends Equatable {
  final String user_uid;

  const UsersCreateFromAnonymousDto({
    required this.user_uid,
  });

  factory UsersCreateFromAnonymousDto.fromJson(Map<String, dynamic> json) =>
      _$UsersCreateFromAnonymousDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UsersCreateFromAnonymousDtoToJson(this);

  @override
  List<Object?> get props => [user_uid];
}
