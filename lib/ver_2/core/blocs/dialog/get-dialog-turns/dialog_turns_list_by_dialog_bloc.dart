import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_event.dart';
import 'package:zingo/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/dialog_turns_service.dart';

class DialogTurnsListByDialogBloc
    extends Bloc<DialogTurnsListByDialogEvent, DialogTurnsListByDialogState> {
  final _service = DialogTurnsService();

  DialogTurnsListByDialogBloc()
    : super(DialogTurnsListByDialogState.initial()) {
    on<DialogTurnsListByDialogFetchEvent>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final result = await _service.getDialogTurnsByDialogId(event.payload);

        emit(
          state.copyWith(requestStatus: RequestStatus.success, data: result),
        );
      } on DioException catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            data: [],
            error: e.response?.data?['message']?.toString() ?? e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            data: [],
            error: e.toString(),
          ),
        );
      }
    });
  }
}
