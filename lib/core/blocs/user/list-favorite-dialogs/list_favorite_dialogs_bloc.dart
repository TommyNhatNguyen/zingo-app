import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/favorite_dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class ListFavoriteDialogsBloc
    extends Bloc<ListFavoriteDialogsEvent, ListFavoriteDialogsState> {
  final FavoriteDialogRepository _repository;

  ListFavoriteDialogsBloc({FavoriteDialogRepository? repository})
      : _repository = repository ??
            FavoriteDialogRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(ListFavoriteDialogsState.initial()) {
    on<ListFavoriteDialogsFetch>(_onFetch);
    on<ListFavoriteDialogsFetchMore>(_onFetchMore);
  }

  Future<void> _onFetch(
    ListFavoriteDialogsFetch event,
    Emitter<ListFavoriteDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.getFavoriteDialogs(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            data: data.data,
            meta: data.meta,
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
  }

  Future<void> _onFetchMore(
    ListFavoriteDialogsFetchMore event,
    Emitter<ListFavoriteDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    final result = await _repository.getFavoriteDialogs(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            data: [...(state.data ?? []), ...(data.data ?? [])],
            meta: data.meta,
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
  }
}
