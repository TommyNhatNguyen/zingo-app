import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/practice-sessions/complete-practice/complete_practice_event.dart';
import 'package:zingo/blocs/practice-sessions/complete-practice/complete_practice_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/practice_sessions_service.dart';

class CompletePracticeBloc
    extends Bloc<CompletePracticeEvent, CompletePracticeState> {
  final PracticeSessionsService _practiceSessionsService;

  CompletePracticeBloc({PracticeSessionsService? practiceSessionsService})
    : _practiceSessionsService =
          practiceSessionsService ?? PracticeSessionsService(),
      super(CompletePracticeState.initial()) {
    on<CompletePracticeSubmit>(_onSubmit);
  }

  Future<void> _onSubmit(
    CompletePracticeSubmit event,
    Emitter<CompletePracticeState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final session = await _practiceSessionsService.completeSession(
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
