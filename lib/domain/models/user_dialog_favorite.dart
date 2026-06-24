import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/domain/models/dialog.dart';

part 'user_dialog_favorite.g.dart';

@JsonSerializable()
class UserDialogFavorite extends Equatable {
  final String user_id;
  final String dialog_id;
  final Dialog dialog;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const UserDialogFavorite({
    required this.user_id,
    required this.dialog_id,
    required this.dialog,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory UserDialogFavorite.fromJson(Map<String, dynamic> json) =>
      _$UserDialogFavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$UserDialogFavoriteToJson(this);

  @override
  List<Object?> get props => [
    user_id,
    dialog_id,
    dialog,
    created_at,
    updated_at,
    deleted_at,
  ];
}
