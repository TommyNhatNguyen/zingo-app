import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_bloc.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_event.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/features/explore/widgets/empty_section.dart';
import 'package:zingo/features/explore/widgets/topic_card.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({super.key});

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  AuthBloc get authBloc => context.read<AuthBloc>();

  void _fetch(String? userId) {
    context.read<ListFavoriteDialogsBloc>().add(
      ListFavoriteDialogsFetch(
        payload: ListFavoriteDialogsPayload(userId: userId),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (authBloc.state.data != null) {
      _fetch(authBloc.state.data!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.data == null && curr.data != null,
      listener: (context, authState) => _fetch(authState.data!.id),
      child: BlocBuilder<ListFavoriteDialogsBloc, ListFavoriteDialogsState>(
        builder: (context, state) {
          return Column(
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
                      "Your favorites",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if ((state.data == null || state.data?.isEmpty == true) &&
                  state.requestStatus != RequestStatus.loading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EmptySection(
                    icon: Icon(Icons.favorite),
                    title: Text(
                      "No favorites yet",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Add your favorite topics to continue practicing",
                      softWrap: true,
                    ),
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.favoriteLight,
                    iconColor: AppColors.favoriteContainer,
                  ),
                )
              else
                Skeletonizer(
                  enabled: state.requestStatus == RequestStatus.loading,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 12,
                      children: (state.data ?? [])
                          .map((d) => TopicCard(dialog: d))
                          .toList(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
