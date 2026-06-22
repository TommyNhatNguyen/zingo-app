import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_streak_payload.g.dart';

@JsonSerializable()
class GetUserStreakPayload extends Equatable {
  final String user_id;
  final int year;

  const GetUserStreakPayload({required this.user_id, required this.year});

  factory GetUserStreakPayload.fromJson(Map<String, dynamic> json) =>
      _$GetUserStreakPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserStreakPayloadToJson(this);

  @override
  List<Object?> get props => [user_id, year];
}
