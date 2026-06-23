import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/practice-sessions/start-practice/start_practice_event.dart';
import 'package:zingo/blocs/practice-sessions/start-practice/start_practice_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/practice_sessions_service.dart';

class StartPracticeBloc extends Bloc<StartPracticeEvent, StartPracticeState> {
  final PracticeSessionsService _practiceSessionsService;

  StartPracticeBloc({PracticeSessionsService? practiceSessionsService})
    : _practiceSessionsService =
          practiceSessionsService ?? PracticeSessionsService(),
      super(StartPracticeState.initial()) {
    on<StartPracticeSubmit>(_onSubmit);
  }

  Future<void> _onSubmit(
    StartPracticeSubmit event,
    Emitter<StartPracticeState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final session = await _practiceSessionsService.startSession(
        event.payload,
      );
      emit(
        state.copyWith(data: session, requestStatus: RequestStatus.success),
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
