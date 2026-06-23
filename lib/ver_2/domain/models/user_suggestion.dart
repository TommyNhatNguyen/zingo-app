import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_suggestion.g.dart';

@JsonSerializable()
class UserSuggestion extends Equatable {
  final String id;
  final String suggestion_id;
  final String user_id;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const UserSuggestion({
    required this.id,
    required this.suggestion_id,
    required this.user_id,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory UserSuggestion.fromJson(Map<String, dynamic> json) =>
      _$UserSuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSuggestionToJson(this);

  @override
  List<Object?> get props => [
    id,
    suggestion_id,
    user_id,
    created_at,
    updated_at,
    deleted_at,
  ];
}
