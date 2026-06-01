import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_event.dart';
import 'package:zingo/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/practice_sessions_service.dart';

class ListActiveDialogsBloc
    extends Bloc<ListActiveDialogsEvent, ListActiveDialogsState> {
  final PracticeSessionsService _practiceSessionsService;

  ListActiveDialogsBloc({PracticeSessionsService? practiceSessionsService})
    : _practiceSessionsService =
          practiceSessionsService ?? PracticeSessionsService(),
      super(ListActiveDialogsState.initial()) {
    on<ListActiveDialogsFetch>(_onListActiveDialogsFetch);
  }

  Future<void> _onListActiveDialogsFetch(
    ListActiveDialogsFetch event,
    Emitter<ListActiveDialogsState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final dialogs = await _practiceSessionsService.getActiveDialogs(
        event.payload,
      );
      emit(
        state.copyWith(dialogs: dialogs, requestStatus: RequestStatus.success),
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
