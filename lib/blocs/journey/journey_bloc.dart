import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/journey/journey_event.dart';
import 'package:zingo/blocs/journey/journey_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/journey_service.dart';

class JourneyBloc extends Bloc<JourneyEvent, JourneyState> {
  final JourneyService _service;

  JourneyBloc({JourneyService? service})
      : _service = service ?? JourneyService(),
        super(JourneyState.initial()) {
    on<JourneyFetchEvent>(_onFetch);
    on<JourneyFetchMoreEvent>(_onFetchMore);
  }

  Future<void> _onFetch(
    JourneyFetchEvent event,
    Emitter<JourneyState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final result = await _service.getJourney(event.payload);
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        chapters: result.chapters,
        meta: result.meta,
        error: null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        requestStatus: RequestStatus.error,
        error: e.response?.data?['message']?.toString() ?? e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        requestStatus: RequestStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onFetchMore(
    JourneyFetchMoreEvent event,
    Emitter<JourneyState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    try {
      final result = await _service.getJourney(event.payload);
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        chapters: [...state.chapters, ...result.chapters],
        meta: result.meta,
        error: null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        requestStatus: RequestStatus.error,
        error: e.response?.data?['message']?.toString() ?? e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        requestStatus: RequestStatus.error,
        error: e.toString(),
      ));
    }
  }
}
