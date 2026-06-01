import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart';

class ListActiveDialogsState extends Equatable {
  const ListActiveDialogsState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  final List<Dialog>? data;
  final RequestStatus requestStatus;
  final String? error;

  factory ListActiveDialogsState.initial() {
    return const ListActiveDialogsState(
      data: [],
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  ListActiveDialogsState copyWith({
    List<Dialog>? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return ListActiveDialogsState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
