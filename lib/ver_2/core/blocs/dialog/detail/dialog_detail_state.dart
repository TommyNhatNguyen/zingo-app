import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart';

class DialogDetailState extends Equatable {
  final Dialog? data;
  final RequestStatus requestStatus;
  final String? error;

  const DialogDetailState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory DialogDetailState.initial() {
    return const DialogDetailState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  DialogDetailState copyWith({
    Dialog? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return DialogDetailState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
