import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic extends Equatable {
  final String normalize_name;
  final String name;
  final String? thumbnail_url;
  final String? icon_url;
  final String? emoji;
  final String? parent_topic_normalize_name;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const Topic({
    required this.normalize_name,
    required this.name,
    this.thumbnail_url,
    this.icon_url,
    this.emoji,
    this.parent_topic_normalize_name,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

  @override
  List<Object?> get props => [
    normalize_name,
    name,
    thumbnail_url,
    icon_url,
    emoji,
    parent_topic_normalize_name,
    created_at,
    updated_at,
    deleted_at,
  ];
}
