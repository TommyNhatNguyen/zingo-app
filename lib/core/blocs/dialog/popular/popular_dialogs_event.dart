import 'package:equatable/equatable.dart';
import 'package:zingo/domain/dtos/dialog/popular_dialogs_payload.dart';

abstract class PopularDialogsEvent extends Equatable {
  const PopularDialogsEvent();

  @override
  List<Object?> get props => [];
}

class PopularDialogsFetchEvent extends PopularDialogsEvent {
  final PopularDialogsPayload payload;

  const PopularDialogsFetchEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class PopularDialogsFetchMoreEvent extends PopularDialogsEvent {
  final PopularDialogsPayload payload;

  const PopularDialogsFetchMoreEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}
