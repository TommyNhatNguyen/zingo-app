import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zingo/core/constants/enums.dart';

part 'dialog_list_payload.g.dart';

@JsonSerializable()
class OrderByItem extends Equatable {
  final String column;
  final String direction;

  const OrderByItem({required this.column, this.direction = 'asc'});

  factory OrderByItem.fromJson(Map<String, dynamic> json) =>
      _$OrderByItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderByItemToJson(this);

  @override
  List<Object?> get props => [column, direction];
}

@JsonSerializable(includeIfNull: false)
class DialogListQuery extends Equatable {
  final List<DialogDuration>? durations;
  @JsonKey(name: 'cefr_levels')
  final List<EnglishLevel>? cefrLevels;
  @JsonKey(name: 'topic_ids')
  final List<String>? topicIds;

  const DialogListQuery({this.durations, this.cefrLevels, this.topicIds});

  factory DialogListQuery.fromJson(Map<String, dynamic> json) =>
      _$DialogListQueryFromJson(json);
  Map<String, dynamic> toJson() => _$DialogListQueryToJson(this);

  DialogListQuery copyWith({
    List<DialogDuration>? durations,
    List<EnglishLevel>? cefrLevels,
    List<String>? topicIds,
  }) {
    return DialogListQuery(
      durations: durations ?? this.durations,
      cefrLevels: cefrLevels ?? this.cefrLevels,
      topicIds: topicIds ?? this.topicIds,
    );
  }

  @override
  List<Object?> get props => [durations, cefrLevels, topicIds];
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class DialogListPayload extends Equatable {
  final int page;
  final int limit;
  final List<OrderByItem>? orderBy;
  final DialogListQuery? query;

  const DialogListPayload({
    this.page = 1,
    this.limit = 10,
    this.orderBy,
    this.query,
  });

  factory DialogListPayload.fromJson(Map<String, dynamic> json) =>
      _$DialogListPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$DialogListPayloadToJson(this);

  DialogListPayload copyWith({
    int? page,
    int? limit,
    List<OrderByItem>? orderBy,
    DialogListQuery? query,
  }) {
    return DialogListPayload(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      orderBy: orderBy ?? this.orderBy,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [page, limit, orderBy, query];
}
