import 'package:equatable/equatable.dart';

class JourneyPayload extends Equatable {
  final int page;
  final int pageSize;

  const JourneyPayload({this.page = 1, this.pageSize = 5});

  Map<String, dynamic> toJson() => {
    'page': page.toString(),
    'pageSize': pageSize.toString(),
  };

  JourneyPayload copyWith({int? page, int? pageSize}) {
    return JourneyPayload(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [page, pageSize];
}
