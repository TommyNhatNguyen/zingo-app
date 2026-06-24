import 'package:equatable/equatable.dart';
import 'package:zingo/domain/dtos/dialog/recent_dialogs_payload.dart';

abstract class RecentDialogsEvent extends Equatable {
  const RecentDialogsEvent();

  @override
  List<Object?> get props => [];
}

class RecentDialogsFetchEvent extends RecentDialogsEvent {
  final String userId;
  final RecentDialogsPayload payload;

  const RecentDialogsFetchEvent({required this.userId, required this.payload});

  @override
  List<Object?> get props => [userId, payload];
}

class RecentDialogsFetchMoreEvent extends RecentDialogsEvent {
  final String userId;
  final RecentDialogsPayload payload;

  const RecentDialogsFetchMoreEvent({
    required this.userId,
    required this.payload,
  });

  @override
  List<Object?> get props => [userId, payload];
}
