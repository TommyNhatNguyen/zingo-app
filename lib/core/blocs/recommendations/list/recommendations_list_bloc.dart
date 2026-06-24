import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/recommendations/list/recommendations_list_event.dart';
import 'package:zingo/core/blocs/recommendations/list/recommendations_list_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/recommendation_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class RecommendationsListBloc
    extends Bloc<RecommendationsListEvent, RecommendationsListState> {
  final RecommendationRepository _repository;

  RecommendationsListBloc({RecommendationRepository? repository})
      : _repository = repository ??
            RecommendationRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(RecommendationsListState.initial()) {
    on<RecommendationsListFetch>(_onFetch);
    on<RecommendationsListFetchMore>(_onFetchMore);
  }

  Future<void> _onFetch(
    RecommendationsListFetch event,
    Emitter<RecommendationsListState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.getRecommendations(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(requestStatus: RequestStatus.success, data: data),
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

  Future<void> _onFetchMore(
    RecommendationsListFetchMore event,
    Emitter<RecommendationsListState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    final result = await _repository.getRecommendations(event.payload);
    switch (result) {
      case Ok(:final data):
        final merged = data == null
            ? state.data
            : state.data == null
                ? data
                : state.data!.copyWithChapters(data.chapters);
        emit(
          state.copyWith(requestStatus: RequestStatus.success, data: merged),
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
