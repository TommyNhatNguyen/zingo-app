import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users.g.dart';

@JsonSerializable()
class Users extends Equatable {
  final String id;
  final String user_uid;
  final String email;
  final String username;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const Users({
    required this.id,
    required this.user_uid,
    required this.email,
    required this.username,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);

  @override
  List<Object?> get props => [
    id,
    user_uid,
    email,
    username,
    created_at,
    updated_at,
    deleted_at,
  ];
}
