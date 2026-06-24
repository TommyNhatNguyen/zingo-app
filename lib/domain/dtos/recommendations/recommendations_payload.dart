import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommendations_payload.g.dart';

@JsonSerializable()
class RecommendationsPayload extends Equatable {
  // ignore: non_constant_identifier_names
  final String user_id;
  final int page;
  final int pageSize;

  const RecommendationsPayload({
    required this.user_id,
    this.page = 1,
    this.pageSize = 5,
  });

  factory RecommendationsPayload.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationsPayloadToJson(this);

  RecommendationsPayload copyWith({String? user_id, int? page, int? pageSize}) {
    return RecommendationsPayload(
      user_id: user_id ?? this.user_id,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [user_id, page, pageSize];
}
