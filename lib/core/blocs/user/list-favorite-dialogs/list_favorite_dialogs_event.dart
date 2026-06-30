import 'package:equatable/equatable.dart';

abstract class ListFavoriteDialogsEvent extends Equatable {
  const ListFavoriteDialogsEvent();

  @override
  List<Object?> get props => [];
}

class ListFavoriteDialogsFetchNextPageEvent extends ListFavoriteDialogsEvent {
  const ListFavoriteDialogsFetchNextPageEvent();
}

class ListFavoriteDialogsRefreshEvent extends ListFavoriteDialogsEvent {
  final String? userId;

  const ListFavoriteDialogsRefreshEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}
