import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/models/user_dialog_favorite.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/explore/widgets/empty_section.dart';
import 'package:zingo/ui/explore/widgets/topic_card.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({super.key});

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  static const _listHeight = 158.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFavorites());
  }

  void _refreshFavorites() {
    final userId = context.read<AuthBloc>().state.data?.id;
    context.read<ListFavoriteDialogsBloc>().add(
      ListFavoriteDialogsRefreshEvent(userId: userId),
    );
  }

  Widget _buildSkeletonRow() {
    return Skeletonizer(
      enabled: true,
      child: Row(
        spacing: 12,
        children: List.generate(3, (_) => const TopicCard()),
      ),
    );
  }

  Widget _buildEmptySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: EmptySection(
        icon: Icon(Icons.favorite),
        title: Text(
          context.l10n.noFavoritesYet,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(context.l10n.addFavoritesHint, softWrap: true),
        backgroundColor: AppColors.white,
        borderColor: AppColors.favoriteLight,
        iconColor: AppColors.favoriteContainer,
      ),
    );
  }

  Widget _buildErrorSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: EmptySection(
        icon: Icon(Icons.favorite),
        title: Text(
          context.l10n.errorGeneric,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: TextButton.icon(
          onPressed: _refreshFavorites,
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(context.l10n.retry),
        ),
        backgroundColor: AppColors.white,
        borderColor: AppColors.favoriteLight,
        iconColor: AppColors.favoriteContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.select((AuthBloc bloc) => bloc.state.data?.id);
    if (userId == null) return const SizedBox.shrink();

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (prev, curr) => prev.data?.id != curr.data?.id,
          listener: (context, authState) {
            context.read<ListFavoriteDialogsBloc>().add(
              ListFavoriteDialogsRefreshEvent(userId: authState.data?.id),
            );
          },
        ),
      ],
      child:
          BlocBuilder<
            ListFavoriteDialogsBloc,
            PagingState<int, UserDialogFavorite>
          >(
            builder: (context, state) {
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
                    if (state.status == PagingStatus.firstPageError)
                      _buildErrorSection(context)
                    else if (state.status == PagingStatus.noItemsFound)
                      _buildEmptySection(context)
                    else
                      SizedBox(
                        height: _listHeight,
                        child: PagedListView<int, UserDialogFavorite>.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          state: state,
                          fetchNextPage: context
                              .read<ListFavoriteDialogsBloc>()
                              .fetchNextPage,
                          builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: (context, item, index) =>
                                TopicCard(dialog: item.dialog),
                            firstPageProgressIndicatorBuilder: (_) =>
                                _buildSkeletonRow(),
                            newPageProgressIndicatorBuilder: (_) =>
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            invisibleItemsThreshold: 2,
                          ),
                          separatorBuilder: (_, index) =>
                              const SizedBox(width: 12),
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
