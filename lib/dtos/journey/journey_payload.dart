import 'package:equatable/equatable.dart';

class JourneyPayload extends Equatable {
  final int page;
  final int pageSize;
  final String user_id;

  const JourneyPayload({
    this.page = 1,
    this.pageSize = 5,
    required this.user_id,
  });

  Map<String, dynamic> toJson() => {
    'page': page.toString(),
    'pageSize': pageSize.toString(),
    'user_id': user_id,
  };

  JourneyPayload copyWith({int? page, int? pageSize, String? user_id}) {
    return JourneyPayload(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      user_id: user_id ?? this.user_id,
    );
  }

  @override
  List<Object?> get props => [page, pageSize, user_id];
}
