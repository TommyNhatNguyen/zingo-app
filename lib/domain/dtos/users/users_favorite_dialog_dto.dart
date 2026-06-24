import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_favorite_dialog_dto.g.dart';

@JsonSerializable()
class UsersFavoriteDialogDto extends Equatable{
  final String dialog_id;
  final String user_id;

  const UsersFavoriteDialogDto({
    required this.dialog_id,
    required this.user_id,
  });

  factory UsersFavoriteDialogDto.fromJson(Map<String, dynamic> json) => _$UsersFavoriteDialogDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UsersFavoriteDialogDtoToJson(this);

  @override
  List<Object?> get props => [dialog_id, user_id];
}