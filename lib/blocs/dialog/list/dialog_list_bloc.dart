import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/dialog_service.dart';

class DialogListBloc extends Bloc<DialogListEvent, DialogListState> {
  final _service = DialogService();
  DialogListBloc() : super(DialogListState.initial()) {
    on<DialogListFetchEvent>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final result = await _service.getDialogs(event.payload);

        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            data: result.data,
            meta: result.meta,
            error: result.error,
          ),
        );
      } on DioException catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            data: [],
            meta: null,
            error: e.response?.data?['message']?.toString() ?? e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            data: [],
            meta: null,
            error: e.toString(),
          ),
        );
      }
    });

    on<DialogListFetchMoreEvent>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
        final result = await _service.getDialogs(event.payload);

        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            data: [...(state.data ?? []), ...(result.data ?? [])],
            meta: result.meta,
            error: result.error,
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
