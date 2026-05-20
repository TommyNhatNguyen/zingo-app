import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/dialog/dialog_detail_payload.dart';

abstract class DialogDetailEvent extends Equatable {
  const DialogDetailEvent();

  @override
  List<Object?> get props => [];
}

class DialogDetailFetchEvent extends DialogDetailEvent {
  final DialogDetailPayload payload;
  const DialogDetailFetchEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}
