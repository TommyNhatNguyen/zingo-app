import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_event.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class DialogDetailBloc extends Bloc<DialogDetailEvent, DialogDetailState> {
  final DialogRepository _repository;

  DialogDetailBloc({DialogRepository? repository})
      : _repository =
            repository ?? DialogRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(DialogDetailState.initial()) {
    on<DialogDetailFetchEvent>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      final result = await _repository.getDialogDetail(event.payload);
      switch (result) {
        case Ok(:final data):
          emit(
            state.copyWith(requestStatus: RequestStatus.success, data: data),
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
