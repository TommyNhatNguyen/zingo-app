import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/user_dialog_favorite.dart';

class ListFavoriteDialogsState extends Equatable {
  const ListFavoriteDialogsState({
    this.data,
    this.meta,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  final List<UserDialogFavorite>? data;
  final PaginationMeta? meta;
  final RequestStatus requestStatus;
  final String? error;

  factory ListFavoriteDialogsState.initial() {
    return const ListFavoriteDialogsState(
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

  ListFavoriteDialogsState copyWith({
    List<UserDialogFavorite>? data,
    PaginationMeta? meta,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return ListFavoriteDialogsState(
      data: data ?? this.data,
      meta: meta ?? this.meta,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, meta, requestStatus, error];
}
