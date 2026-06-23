import 'package:equatable/equatable.dart';

class RecentDialogsPayload extends Equatable {
  final int page;
  final int pageSize;

  const RecentDialogsPayload({this.page = 1, this.pageSize = 10});

  Map<String, dynamic> toJson() => {'page': page, 'pageSize': pageSize};

  RecentDialogsPayload copyWith({int? page, int? pageSize}) =>
      RecentDialogsPayload(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );

  @override
  List<Object?> get props => [page, pageSize];
}
