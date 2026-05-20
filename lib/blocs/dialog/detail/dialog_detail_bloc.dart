import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_event.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/dialog_service.dart';

class DialogDetailBloc extends Bloc<DialogDetailEvent, DialogDetailState> {
  final _service = DialogService();

  DialogDetailBloc() : super(DialogDetailState.initial()) {
    on<DialogDetailFetchEvent>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final result = await _service.getDialogDetail(event.payload);
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            data: result,
          ),
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
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.toString(),
          ),
        );
      }
    });
  }
}
