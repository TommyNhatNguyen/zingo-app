import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/domain/models/dialog.dart';

class PopularDialogsState extends Equatable {
  final List<Dialog>? data;
  final PaginationMeta? meta;
  final RequestStatus requestStatus;
  final String? error;

  const PopularDialogsState({
    this.data,
    this.meta,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory PopularDialogsState.initial() => const PopularDialogsState(data: []);

  bool get hasMore {
    if (meta == null) return false;
    return meta!.page < meta!.totalPages;
  }

  PopularDialogsState copyWith({
    List<Dialog>? data,
    PaginationMeta? meta,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return PopularDialogsState(
      data: data ?? this.data,
      meta: meta ?? this.meta,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, meta, requestStatus, error];
}
