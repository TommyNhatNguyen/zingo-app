import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/domain/models/dialog.dart';

class RecentDialogsState extends Equatable {
  final List<Dialog>? data;
  final PaginationMeta? meta;
  final RequestStatus requestStatus;
  final String? error;

  const RecentDialogsState({
    this.data,
    this.meta,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory RecentDialogsState.initial() => const RecentDialogsState(data: []);

  bool get hasMore {
    if (meta == null) return false;
    return meta!.page < meta!.totalPages;
  }

  RecentDialogsState copyWith({
    List<Dialog>? data,
    PaginationMeta? meta,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return RecentDialogsState(
      data: data ?? this.data,
      meta: meta ?? this.meta,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, meta, requestStatus, error];
}
