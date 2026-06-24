import 'package:equatable/equatable.dart';
import 'package:zingo/domain/dtos/users/users_favorite_dialog_dto.dart';

abstract class FavoriteDialogEvent extends Equatable {
  const FavoriteDialogEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteDialogAddEvent extends FavoriteDialogEvent {
  final UsersFavoriteDialogDto payload;
  const FavoriteDialogAddEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class FavoriteDialogRemoveEvent extends FavoriteDialogEvent {
  final UsersFavoriteDialogDto payload;
  const FavoriteDialogRemoveEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}
