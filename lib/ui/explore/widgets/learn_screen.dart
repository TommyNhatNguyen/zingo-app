import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/core/blocs/dialog/popular/popular_dialogs_bloc.dart';
import 'package:zingo/core/blocs/dialog/popular/popular_dialogs_event.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/explore/widgets/continue_practice_section.dart';
import 'package:zingo/ui/explore/widgets/favorite_section.dart';
import 'package:zingo/ui/explore/widgets/recommendation_section.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final media = MediaQuery.of(context);
    if (pos.pixels > media.size.height / 2) {
      setState(() => _showScrollToTop = true);
    } else {
      setState(() => _showScrollToTop = false);
    }
  }

  Future<void> _onRefresh() async {
    final userId = context.read<AuthBloc>().state.data?.id;
    context.read<ListFavoriteDialogsBloc>().add(
      ListFavoriteDialogsRefreshEvent(userId: userId),
    );
    context.read<DialogListBloc>().add(const DialogListRefreshEvent());
    context.read<PopularDialogsBloc>().add(const PopularDialogsRefreshEvent());
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.white,
              stretch: false,
              floating: true,
              snap: true,
              pinned: true,
              elevation: 4,
              shadowColor: AppColors.shadow,
              shape: const Border(bottom: BorderSide(color: AppColors.divider)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.browseAllDialogs),
                  Text(
                    context.l10n.browseSubtitle,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              sliver: SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: const [
                        ContinuePracticeSection(),
                        FavoriteSection(),
                        RecommendationSection(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _showScrollToTop
            ? FloatingActionButton(
                onPressed: () => _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: const Icon(Icons.arrow_upward),
              )
            : null,
      ),
    );
  }
}
