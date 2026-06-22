import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

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

@JsonSerializable(explicitToJson: true)
class DialogListPayload extends Equatable {
  final int page;
  final int limit;
  final List<OrderByItem>? orderBy;

  const DialogListPayload({this.page = 1, this.limit = 10, this.orderBy});

  factory DialogListPayload.fromJson(Map<String, dynamic> json) =>
      _$DialogListPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$DialogListPayloadToJson(this);

  @override
  List<Object?> get props => [page, limit, orderBy];
}
