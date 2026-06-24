import 'package:equatable/equatable.dart';
import 'package:zingo/domain/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';

class DialogTurnsListByDialogEvent extends Equatable {
  const DialogTurnsListByDialogEvent();

  @override
  List<Object?> get props => [];
}

class DialogTurnsListByDialogFetchEvent extends DialogTurnsListByDialogEvent {
  final DialogTurnsByDialogIdPayload payload;
  const DialogTurnsListByDialogFetchEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}
