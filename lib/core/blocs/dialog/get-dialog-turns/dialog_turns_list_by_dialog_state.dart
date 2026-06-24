import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/models/dialog_turn.dart';

class DialogTurnsListByDialogState extends Equatable {
  final List<DialogTurn>? data;
  final RequestStatus requestStatus;
  final String? error;

  const DialogTurnsListByDialogState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory DialogTurnsListByDialogState.initial() {
    return const DialogTurnsListByDialogState(
      data: [],
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  DialogTurnsListByDialogState copyWith({
    List<DialogTurn>? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return DialogTurnsListByDialogState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
