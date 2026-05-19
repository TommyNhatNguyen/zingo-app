import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/dialog/dialog_list_payload.dart';

class DialogListEvent extends Equatable {
  const DialogListEvent();

  @override
  List<Object?> get props => [];
}

class DialogListFetchEvent extends DialogListEvent {
  final DialogListPayload payload;
  const DialogListFetchEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class DialogListFetchMoreEvent extends DialogListEvent {
  final DialogListPayload payload;
  const DialogListFetchMoreEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class DialogRefreshEvent extends DialogListEvent {
  const DialogRefreshEvent();

  @override
  List<Object?> get props => [];
}
