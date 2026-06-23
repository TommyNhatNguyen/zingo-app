import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/blocs/user/list-favorite-dialogs/list_favorite_dialogs_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/user_favorite_dialogs_service.dart';

class ListFavoriteDialogsBloc
    extends Bloc<ListFavoriteDialogsEvent, ListFavoriteDialogsState> {
  final UserFavoriteDialogsService _userFavoriteDialogsService;

  ListFavoriteDialogsBloc({
    UserFavoriteDialogsService? userFavoriteDialogsService,
  }) : _userFavoriteDialogsService =
           userFavoriteDialogsService ?? UserFavoriteDialogsService(),
       super(ListFavoriteDialogsState.initial()) {
    on<ListFavoriteDialogsFetch>(_onFetch);
    on<ListFavoriteDialogsFetchMore>(_onFetchMore);
  }

  Future<void> _onFetch(
    ListFavoriteDialogsFetch event,
    Emitter<ListFavoriteDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final result = await _userFavoriteDialogsService.getFavoriteDialogs(
        event.payload,
      );
      emit(
        state.copyWith(
          data: result.data,
          meta: result.meta,
          requestStatus: RequestStatus.success,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          error: e.response?.data?['message']?.toString() ?? e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(requestStatus: RequestStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onFetchMore(
    ListFavoriteDialogsFetchMore event,
    Emitter<ListFavoriteDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    try {
      final result = await _userFavoriteDialogsService.getFavoriteDialogs(
        event.payload,
      );
      emit(
        state.copyWith(
          data: [...(state.data ?? []), ...(result.data ?? [])],
          meta: result.meta,
          requestStatus: RequestStatus.success,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          error: e.response?.data?['message']?.toString() ?? e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(requestStatus: RequestStatus.error, error: e.toString()),
      );
    }
  }
}
