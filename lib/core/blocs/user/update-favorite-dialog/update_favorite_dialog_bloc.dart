import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_event.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/favorite_dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class FavoriteDialogBloc
    extends Bloc<FavoriteDialogEvent, FavoriteDialogState> {
  final FavoriteDialogRepository _repository;

  FavoriteDialogBloc({FavoriteDialogRepository? repository})
      : _repository = repository ??
            FavoriteDialogRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(FavoriteDialogState()) {
    on<FavoriteDialogAddEvent>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      final result = await _repository.addFavorite(event.payload);
      switch (result) {
        case Ok(:final data) when data:
          emit(
            state.copyWith(
              isFavorite: true,
              requestStatus: RequestStatus.success,
            ),
          );
        case Ok():
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: 'Failed to add favorite',
            ),
          );
        case Error(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: error.toString(),
            ),
          );
        case ErrorAPI(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: error.error.detail,
            ),
          );
      }
    });

    on<FavoriteDialogRemoveEvent>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      final result = await _repository.removeFavorite(event.payload);
      switch (result) {
        case Ok():
          emit(
            state.copyWith(
              isFavorite: false,
              requestStatus: RequestStatus.success,
            ),
          );
        case Error(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: error.toString(),
            ),
          );
        case ErrorAPI(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: error.error.detail,
            ),
          );
      }
    });
  }
}
