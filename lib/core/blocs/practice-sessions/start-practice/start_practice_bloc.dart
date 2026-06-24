import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_event.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/practice_session_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class StartPracticeBloc extends Bloc<StartPracticeEvent, StartPracticeState> {
  final PracticeSessionRepository _repository;

  StartPracticeBloc({PracticeSessionRepository? repository})
      : _repository = repository ??
            PracticeSessionRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(StartPracticeState.initial()) {
    on<StartPracticeSubmit>(_onSubmit);
  }

  Future<void> _onSubmit(
    StartPracticeSubmit event,
    Emitter<StartPracticeState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.startSession(event.payload);
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
