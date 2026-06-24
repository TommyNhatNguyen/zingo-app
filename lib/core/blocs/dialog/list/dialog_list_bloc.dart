import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class DialogListBloc extends Bloc<DialogListEvent, DialogListState> {
  final DialogRepository _repository;

  DialogListBloc({DialogRepository? repository})
      : _repository =
            repository ?? DialogRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(DialogListState.initial()) {
    on<DialogListFetchEvent>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      final result = await _repository.getDialogs(event.payload);
      switch (result) {
        case Ok(:final data):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.success,
              data: data.data,
              meta: data.meta,
              error: data.error,
            ),
          );
        case Error(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              data: [],
              meta: null,
              error: error.toString(),
            ),
          );
        case ErrorAPI(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              data: [],
              meta: null,
              error: error.error.detail,
            ),
          );
      }
    });

    on<DialogListFetchMoreEvent>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
      final result = await _repository.getDialogs(event.payload);
      switch (result) {
        case Ok(:final data):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.success,
              data: [...(state.data ?? []), ...(data.data ?? [])],
              meta: data.meta,
              error: data.error,
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
