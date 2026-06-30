import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/favorite_dialog_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/domain/models/user_dialog_favorite.dart';

class ListFavoriteDialogsBloc
    extends Bloc<ListFavoriteDialogsEvent, PagingState<int, UserDialogFavorite>> {
  static const _pageSize = 10;

  final FavoriteDialogRepository _repository;
  String? _userId;

  ListFavoriteDialogsBloc({FavoriteDialogRepository? repository})
    : _repository =
          repository ??
          FavoriteDialogRepository(
            apiClientService: ApiClientService(httpClient: dio),
          ),
      super(PagingState()) {
    on<ListFavoriteDialogsFetchNextPageEvent>(_onFetchNextPage);
    on<ListFavoriteDialogsRefreshEvent>(_onRefresh);
  }

  void fetchNextPage() => add(const ListFavoriteDialogsFetchNextPageEvent());

  Future<void> _onFetchNextPage(
    ListFavoriteDialogsFetchNextPageEvent event,
    Emitter<PagingState<int, UserDialogFavorite>> emit,
  ) async {
    if (_userId == null) return;
    if (state.isLoading) return;
    if (state.pages != null && !state.hasNextPage) return;

    final pageKey = state.nextIntPageKey;
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _repository.getFavoriteDialogs(
      ListFavoriteDialogsPayload(
        userId: _userId,
        page: pageKey,
        limit: _pageSize,
      ),
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
    ListFavoriteDialogsRefreshEvent event,
    Emitter<PagingState<int, UserDialogFavorite>> emit,
  ) async {
    _userId = event.userId;
    emit(state.reset());
    if (_userId != null) {
      add(const ListFavoriteDialogsFetchNextPageEvent());
    }
  }
}
