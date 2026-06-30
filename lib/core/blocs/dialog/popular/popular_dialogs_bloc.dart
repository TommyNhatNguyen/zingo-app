import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/dialog/popular/popular_dialogs_event.dart';
import 'package:zingo/core/blocs/dialog/popular/popular_dialogs_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class PopularDialogsBloc
    extends Bloc<PopularDialogsEvent, PopularDialogsState> {
  final DialogRepository _repository;

  PopularDialogsBloc({DialogRepository? repository})
    : _repository =
          repository ??
          DialogRepository(apiClientService: ApiClientService(httpClient: dio)),
      super(PopularDialogsState.initial()) {
    on<PopularDialogsFetchEvent>(_onFetch);
    on<PopularDialogsFetchMoreEvent>(_onFetchMore);
  }

  Future<void> _onFetch(
    PopularDialogsFetchEvent event,
    Emitter<PopularDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.getPopularDialogs(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            data: data.data,
            meta: data.meta,
            error: null,
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
    PopularDialogsFetchMoreEvent event,
    Emitter<PopularDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    final result = await _repository.getPopularDialogs(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            data: [...(state.data ?? []), ...(data.data ?? [])],
            meta: data.meta,
            error: null,
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
