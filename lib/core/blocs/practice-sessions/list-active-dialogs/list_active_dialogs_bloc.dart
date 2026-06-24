import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_event.dart';
import 'package:zingo/core/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/practice_session_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class ListActiveDialogsBloc
    extends Bloc<ListActiveDialogsEvent, ListActiveDialogsState> {
  final PracticeSessionRepository _repository;

  ListActiveDialogsBloc({PracticeSessionRepository? repository})
      : _repository = repository ??
            PracticeSessionRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(ListActiveDialogsState.initial()) {
    on<ListActiveDialogsFetch>(_onListActiveDialogsFetch);
  }

  Future<void> _onListActiveDialogsFetch(
    ListActiveDialogsFetch event,
    Emitter<ListActiveDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.getActiveDialogs(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(data: data, requestStatus: RequestStatus.success),
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
