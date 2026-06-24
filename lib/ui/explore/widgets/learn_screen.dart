import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_event.dart';
import 'package:zingo/core/blocs/recommendations/list/recommendations_list_bloc.dart';
import 'package:zingo/core/blocs/recommendations/list/recommendations_list_event.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_event.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/domain/dtos/practice-sessions/list_active_dialogs_payload.dart';
import 'package:zingo/domain/dtos/recommendations/recommendations_payload.dart';
import 'package:zingo/domain/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/ui/explore/widgets/continue_practice_section.dart';
import 'package:zingo/ui/explore/widgets/favorite_section.dart';
import 'package:zingo/ui/explore/widgets/recommendation_section.dart';
import 'package:zingo/core/l10n/l10n.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  Future<void> _onRefresh() async {
    final userId = context.read<AuthBloc>().state.data?.id;

    context.read<ListActiveDialogsBloc>().add(
      ListActiveDialogsFetch(payload: ListActiveDialogsPayload(userId: userId)),
    );
    context.read<ListFavoriteDialogsBloc>().add(
      ListFavoriteDialogsFetch(
        payload: ListFavoriteDialogsPayload(userId: userId),
      ),
    );
    context.read<RecommendationsListBloc>().add(
      RecommendationsListFetch(
        payload: RecommendationsPayload(user_id: userId ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actionsPadding: const EdgeInsets.only(right: 16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.browseAllDialogs),
            Text(
              context.l10n.browseSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                ContinuePracticeSection(),
                FavoriteSection(),
                RecommendationSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
