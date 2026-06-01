import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/recommendations/list/recommendations_list_event.dart';
import 'package:zingo/blocs/recommendations/list/recommendations_list_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/recommendations_service.dart';

class RecommendationsListBloc
    extends Bloc<RecommendationsListEvent, RecommendationsListState> {
  final RecommendationsService _service;

  RecommendationsListBloc({RecommendationsService? service})
    : _service = service ?? RecommendationsService(),
      super(RecommendationsListState.initial()) {
    on<RecommendationsListFetch>(_onFetch);
    on<RecommendationsListFetchMore>(_onFetchMore);
  }

  Future<void> _onFetch(
    RecommendationsListFetch event,
    Emitter<RecommendationsListState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final result = await _service.getRecommendations(event.payload);
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
  }

  Future<void> _onFetchMore(
    RecommendationsListFetchMore event,
    Emitter<RecommendationsListState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    try {
      final result = await _service.getRecommendations(event.payload);
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
  }
}
