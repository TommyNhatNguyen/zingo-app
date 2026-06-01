import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/dialog.dart';

class ListActiveDialogsState extends Equatable {
  const ListActiveDialogsState({
    this.dialogs,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  final List<Dialog>? dialogs;
  final RequestStatus requestStatus;
  final String? error;

  factory ListActiveDialogsState.initial() {
    return const ListActiveDialogsState(
      dialogs: [],
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  ListActiveDialogsState copyWith({
    List<Dialog>? dialogs,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return ListActiveDialogsState(
      dialogs: dialogs ?? this.dialogs,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [dialogs, requestStatus, error];
}
