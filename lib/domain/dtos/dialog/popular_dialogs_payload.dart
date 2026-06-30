import 'package:equatable/equatable.dart';

class PopularDialogsPayload extends Equatable {
  final int page;
  final int pageSize;

  const PopularDialogsPayload({this.page = 1, this.pageSize = 10});

  Map<String, dynamic> toJson() => {'page': page, 'pageSize': pageSize};

  PopularDialogsPayload copyWith({int? page, int? pageSize}) =>
      PopularDialogsPayload(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );

  @override
  List<Object?> get props => [page, pageSize];
}
