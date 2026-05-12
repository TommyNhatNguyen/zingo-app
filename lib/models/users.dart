import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users.g.dart';

@JsonSerializable()
class Users extends Equatable {
  final String id;
  final String user_uid;
  final String email;
  final String username;
  final String cefr_level;
  final String level;
  final int xp;
  final int streak;
  final DateTime? last_practice_at;
  final DateTime created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const Users({
    required this.id,
    required this.user_uid,
    required this.email,
    required this.username,
    required this.cefr_level,
    required this.level,
    required this.xp,
    required this.streak,
    this.last_practice_at,
    required this.created_at,
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
    cefr_level,
    level,
    xp,
    streak,
    last_practice_at,
    created_at,
    updated_at,
    deleted_at,
  ];
}
