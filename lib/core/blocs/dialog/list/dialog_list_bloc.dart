import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/dialog/dialog_list_payload.dart';

class DialogListBloc extends Bloc<DialogListEvent, DialogListState> {
  static const _pageLimit = 10;

  final DialogRepository _repository;

  DialogListBloc({DialogRepository? repository})
    : _repository =
          repository ??
          DialogRepository(apiClientService: ApiClientService(httpClient: dio)),
      super(DialogListState.initial()) {
    on<DialogListStarted>(_onReload, transformer: restartable());
    on<DialogListFiltersChanged>(_onFiltersChanged, transformer: restartable());
    on<DialogListRefreshEvent>(_onReload, transformer: restartable());
    on<DialogListFetchMoreEvent>(_onFetchMore, transformer: sequential());
  }

  DialogListQuery? _buildQuery(DialogListState source) {
    if (source.cefrLevels.isEmpty &&
        source.durations.isEmpty &&
        source.topicIds.isEmpty) {
      return null;
    }
    return DialogListQuery(
      cefrLevels: source.cefrLevels.isEmpty ? null : source.cefrLevels,
      durations: source.durations.isEmpty ? null : source.durations,
      topicIds: source.topicIds.isEmpty ? null : source.topicIds,
    );
  }

  DialogListPayload _buildPayload(DialogListState source, {int page = 1}) {
    return DialogListPayload(
      page: page,
      limit: _pageLimit,
      query: _buildQuery(source),
    );
  }

  Future<void> _fetchPage(
    Emitter<DialogListState> emit,
    DialogListState source, {
    required int page,
    required bool append,
  }) async {
    if (!append) {
      emit(
        source.copyWith(
          requestStatus: RequestStatus.loading,
          data: const [],
          error: null,
        ),
      );
    } else {
      emit(
        source.copyWith(
          requestStatus: RequestStatus.loadingMore,
          error: null,
        ),
      );
    }

    final result = await _repository.getDialogs(
      _buildPayload(source, page: page),
    );

    switch (result) {
      case Ok(:final data):
        final items = data.data ?? const [];
        emit(
          source.copyWith(
            requestStatus: RequestStatus.success,
            data: append ? [...(source.data ?? []), ...items] : items,
            meta: data.meta,
            error: data.error,
          ),
        );
      case Error(:final error):
        emit(
          source.copyWith(
            requestStatus: RequestStatus.error,
            data: append ? source.data : const [],
            meta: append ? source.meta : null,
            error: error.toString(),
          ),
        );
      case ErrorAPI(:final error):
        emit(
          source.copyWith(
            requestStatus: RequestStatus.error,
            data: append ? source.data : const [],
            meta: append ? source.meta : null,
            error: error.error.detail,
          ),
        );
    }
  }

  Future<void> _onReload(
    DialogListEvent event,
    Emitter<DialogListState> emit,
  ) async {
    await _fetchPage(emit, state, page: 1, append: false);
  }

  Future<void> _onFiltersChanged(
    DialogListFiltersChanged event,
    Emitter<DialogListState> emit,
  ) async {
    final next = state.copyWith(
      cefrLevels: event.cefrLevels,
      durations: event.durations,
      topicIds: event.topicIds,
    );
    await _fetchPage(emit, next, page: 1, append: false);
  }

  Future<void> _onFetchMore(
    DialogListFetchMoreEvent event,
    Emitter<DialogListState> emit,
  ) async {
    final nextPage = (state.meta?.page ?? 1) + 1;
    await _fetchPage(emit, state, page: nextPage, append: true);
  }
}
