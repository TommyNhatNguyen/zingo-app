import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zingo/core/blocs/dialog/popular/popular_dialogs_event.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/dialog/popular_dialogs_payload.dart';
import 'package:zingo/domain/models/dialog.dart';

class PopularDialogsBloc
    extends Bloc<PopularDialogsEvent, PagingState<int, Dialog>> {
  static const _pageSize = 10;

  final DialogRepository _repository;

  PopularDialogsBloc({DialogRepository? repository})
    : _repository =
          repository ??
          DialogRepository(apiClientService: ApiClientService(httpClient: dio)),
      super(PagingState()) {
    on<PopularDialogsFetchNextPageEvent>(_onFetchNextPage);
    on<PopularDialogsRefreshEvent>(_onRefresh);
  }

  void fetchNextPage() => add(const PopularDialogsFetchNextPageEvent());

  Future<void> _onFetchNextPage(
    PopularDialogsFetchNextPageEvent event,
    Emitter<PagingState<int, Dialog>> emit,
  ) async {
    if (state.isLoading) return;
    if (state.pages != null && !state.hasNextPage) return;

    final pageKey = state.nextIntPageKey;
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _repository.getPopularDialogs(
      PopularDialogsPayload(page: pageKey, pageSize: _pageSize),
    );

    switch (result) {
      case Ok(:final data):
        final newItems = data.data ?? [];
        final hasNextPage = data.meta.page < data.meta.totalPages;
        emit(
          state.copyWith(
            pages: [...?state.pages, newItems],
            keys: [...?state.keys, pageKey],
            hasNextPage: hasNextPage,
            isLoading: false,
            error: null,
          ),
        );
      case Error(:final error):
        emit(state.copyWith(error: error, isLoading: false));
      case ErrorAPI(:final error):
        emit(state.copyWith(error: error.error.detail, isLoading: false));
    }
  }

  Future<void> _onRefresh(
    PopularDialogsRefreshEvent event,
    Emitter<PagingState<int, Dialog>> emit,
  ) async {
    emit(state.reset());
    add(const PopularDialogsFetchNextPageEvent());
  }
}
