import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_event.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_state.dart';
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
    on<ListFavoriteDialogsFetch>(_onListFavoriteDialogsFetch);
  }

  Future<void> _onListFavoriteDialogsFetch(
    ListFavoriteDialogsFetch event,
    Emitter<ListFavoriteDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final dialogs = await _userFavoriteDialogsService.getFavoriteDialogs(
        event.payload,
      );
      emit(
        state.copyWith(data: dialogs, requestStatus: RequestStatus.success),
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
