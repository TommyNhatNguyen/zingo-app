import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_state.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/ui/explore/widgets/empty_section.dart';
import 'package:zingo/ui/explore/widgets/topic_card.dart';
import 'package:zingo/core/l10n/l10n.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({super.key});

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  final _scrollController = ScrollController();
  AuthBloc get authBloc => context.read<AuthBloc>();

  ListFavoriteDialogsPayload get _basePayload =>
      ListFavoriteDialogsPayload(userId: authBloc.state.data?.id);

  @override
  void initState() {
    super.initState();
    if (authBloc.state.data != null) {
      _fetch(authBloc.state.data!.id);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetch(String? userId) {
    context.read<ListFavoriteDialogsBloc>().add(
      ListFavoriteDialogsFetch(
        payload: ListFavoriteDialogsPayload(userId: userId),
      ),
    );
  }

  void _onScroll() {
    final bloc = context.read<ListFavoriteDialogsBloc>();
    final state = bloc.state;
    if (!_scrollController.hasClients) return;
    final atEnd =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 120;
    if (atEnd &&
        state.hasMore &&
        state.requestStatus != RequestStatus.loading &&
        state.requestStatus != RequestStatus.loadingMore) {
      final nextPage = (state.meta?.page ?? 1) + 1;
      bloc.add(
        ListFavoriteDialogsFetchMore(
          payload: _basePayload.copyWith(page: nextPage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.data == null && curr.data != null,
      listener: (context, authState) => _fetch(authState.data!.id),
      child: BlocBuilder<ListFavoriteDialogsBloc, ListFavoriteDialogsState>(
        builder: (context, state) {
          final isLoading = state.requestStatus == RequestStatus.loading ||
              state.requestStatus == RequestStatus.initial;
          final isLoadingMore =
              state.requestStatus == RequestStatus.loadingMore;
          final isEmpty =
              (state.data == null || state.data!.isEmpty) && !isLoading;
          return AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.favorite, color: AppColors.favorite),
                      Text(
                        context.l10n.yourFavorites,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (isEmpty && state.requestStatus == RequestStatus.success)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: EmptySection(
                      icon: Icon(Icons.favorite),
                      title: Text(
                        context.l10n.noFavoritesYet,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        context.l10n.addFavoritesHint,
                        softWrap: true,
                      ),
                      backgroundColor: AppColors.white,
                      borderColor: AppColors.favoriteLight,
                      iconColor: AppColors.favoriteContainer,
                    ),
                  )
                else
                  Skeletonizer(
                    enabled: isLoading,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        spacing: 12,
                        children: [
                          ...(isLoading
                              ? List<TopicCard>.generate(
                                  3,
                                  (_) => const TopicCard(dialog: null),
                                )
                              : (state.data ?? []).map(
                                  (item) => TopicCard(dialog: item.dialog),
                                )),
                          if (isLoadingMore)
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
