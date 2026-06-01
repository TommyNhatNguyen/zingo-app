import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/dialog.dart';

class RecommendationsListState extends Equatable {
  final List<Dialog>? data;
  final PaginationMeta? meta;
  final RequestStatus requestStatus;
  final String? error;

  const RecommendationsListState({
    this.data,
    this.meta,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory RecommendationsListState.initial() {
    return const RecommendationsListState(
      data: [],
      meta: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  bool get hasMore {
    if (meta == null) return false;
    return (meta!.page * meta!.limit) < meta!.total;
  }

  RecommendationsListState copyWith({
    List<Dialog>? data,
    PaginationMeta? meta,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return RecommendationsListState(
      data: data ?? this.data,
      meta: meta ?? this.meta,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, meta, requestStatus, error];
}
