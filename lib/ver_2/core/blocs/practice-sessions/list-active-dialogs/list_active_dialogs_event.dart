import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/practice-sessions/list_active_dialogs_payload.dart';

class ListActiveDialogsEvent extends Equatable {
  const ListActiveDialogsEvent();

  @override
  List<Object?> get props => [];
}

class ListActiveDialogsFetch extends ListActiveDialogsEvent {
  final ListActiveDialogsPayload payload;

  const ListActiveDialogsFetch({required this.payload});

  @override
  List<Object?> get props => [payload];
}
