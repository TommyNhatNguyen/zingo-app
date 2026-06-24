import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_event.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/recommendation_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class JourneyBloc extends Bloc<JourneyEvent, JourneyState> {
  final RecommendationRepository _repository;

  JourneyBloc({RecommendationRepository? repository})
      : _repository = repository ??
            RecommendationRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(JourneyState.initial()) {
    on<JourneyFetchEvent>(_onFetch);
    on<JourneyFetchMoreEvent>(_onFetchMore);
  }

  Future<void> _onFetch(
    JourneyFetchEvent event,
    Emitter<JourneyState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.getJourney(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            chapters: data.chapters,
            meta: data.meta,
            error: null,
          ),
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
    JourneyFetchMoreEvent event,
    Emitter<JourneyState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loadingMore));
    final result = await _repository.getJourney(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            chapters: [...state.chapters, ...data.chapters],
            meta: data.meta,
            error: null,
          ),
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
