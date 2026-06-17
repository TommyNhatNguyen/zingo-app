import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart';

class ListFavoriteDialogsState extends Equatable {
  const ListFavoriteDialogsState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  final List<Dialog>? data;
  final RequestStatus requestStatus;
  final String? error;

  factory ListFavoriteDialogsState.initial() {
    return const ListFavoriteDialogsState(
      data: [],
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  ListFavoriteDialogsState copyWith({
    List<Dialog>? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return ListFavoriteDialogsState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
