import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_topic_preference.g.dart';

@JsonSerializable()
class UserTopicPreference extends Equatable {
  final String user_id;
  final String topic_normalize_name;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const UserTopicPreference({
    required this.user_id,
    required this.topic_normalize_name,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory UserTopicPreference.fromJson(Map<String, dynamic> json) =>
      _$UserTopicPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserTopicPreferenceToJson(this);

  @override
  List<Object?> get props => [
    user_id,
    topic_normalize_name,
    created_at,
    updated_at,
    deleted_at,
  ];
}
