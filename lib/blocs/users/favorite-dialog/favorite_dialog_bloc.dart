import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_event.dart';
import 'package:zingo/blocs/users/favorite-dialog/favorite_dialog_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/user_favorite_dialog_service.dart';

class FavoriteDialogBloc
    extends Bloc<FavoriteDialogEvent, FavoriteDialogState> {
  final _service = UserFavoriteDialogService();

  FavoriteDialogBloc() : super(FavoriteDialogState.initial()) {
    on<FavoriteDialogAddEvent>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final result = await _service.addFavorite(event.payload);
        if (result) {
          emit(
            state.copyWith(
              isFavorite: true,
              requestStatus: RequestStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: 'Failed to add favorite',
            ),
          );
        }
      } on DioException catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.response?.data?['message']?.toString() ?? e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.toString(),
          ),
        );
      }
    });

    on<FavoriteDialogRemoveEvent>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        await _service.removeFavorite(event.payload);
        emit(
          state.copyWith(
            isFavorite: false,
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
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.toString(),
          ),
        );
      }
    });
  }
}
