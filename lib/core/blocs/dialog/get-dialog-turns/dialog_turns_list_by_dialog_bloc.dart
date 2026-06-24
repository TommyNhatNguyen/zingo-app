import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_event.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/dialog_turns_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class DialogTurnsListByDialogBloc
    extends Bloc<DialogTurnsListByDialogEvent, DialogTurnsListByDialogState> {
  final DialogTurnsRepository _repository;

  DialogTurnsListByDialogBloc({DialogTurnsRepository? repository})
      : _repository = repository ??
            DialogTurnsRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(DialogTurnsListByDialogState.initial()) {
    on<DialogTurnsListByDialogFetchEvent>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      final result = await _repository.getDialogTurnsByDialogId(event.payload);
      switch (result) {
        case Ok(:final data):
          emit(
            state.copyWith(requestStatus: RequestStatus.success, data: data),
          );
        case Error(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              data: [],
              error: error.toString(),
            ),
          );
        case ErrorAPI(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              data: [],
              error: error.error.detail,
            ),
          );
      }
    });
  }
}
