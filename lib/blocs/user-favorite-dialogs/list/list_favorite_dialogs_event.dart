import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';

class ListFavoriteDialogsEvent extends Equatable {
  const ListFavoriteDialogsEvent();

  @override
  List<Object?> get props => [];
}

class ListFavoriteDialogsFetch extends ListFavoriteDialogsEvent {
  final ListFavoriteDialogsPayload payload;

  const ListFavoriteDialogsFetch({required this.payload});

  @override
  List<Object?> get props => [payload];
}
