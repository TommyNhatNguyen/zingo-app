import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/dialog/recent/recent_dialogs_event.dart';
import 'package:zingo/blocs/dialog/recent/recent_dialogs_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/dialog_service.dart';

class RecentDialogsBloc extends Bloc<RecentDialogsEvent, RecentDialogsState> {
  final DialogService _service;

  RecentDialogsBloc({DialogService? service})
    : _service = service ?? DialogService(),
      super(RecentDialogsState.initial()) {
    on<RecentDialogsFetchEvent>(_onFetch);
    on<RecentDialogsFetchMoreEvent>(_onFetchMore);
  }

  Future<void> _onFetch(
    RecentDialogsFetchEvent event,
    Emitter<RecentDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final result = await _service.getRecentDialogs(
        event.userId,
        event.payload,
      );
      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          data: result.data,
          meta: result.meta,
          error: null,
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
    RecentDialogsFetchMoreEvent event,
    Emitter<RecentDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    try {
      final result = await _service.getRecentDialogs(
        event.userId,
        event.payload,
      );
      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          data: [...(state.data ?? []), ...(result.data ?? [])],
          meta: result.meta,
          error: null,
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
