import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_bloc.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_event.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/screens/learn/learn_screen.dart';
import 'package:zingo/screens/learn/widgets/empty_section.dart';
import 'package:zingo/screens/learn/widgets/topic_card.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({super.key});

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  AuthBloc get authBloc => context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
    context.read<ListFavoriteDialogsBloc>().add(
      ListFavoriteDialogsFetch(
        payload: ListFavoriteDialogsPayload(userId: authBloc.state.data?.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListFavoriteDialogsBloc, ListFavoriteDialogsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(Icons.favorite),
                Text(
                  "Your favorites",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if ((state.data == null || state.data?.isEmpty == true) &&
                state.requestStatus != RequestStatus.loading)
              EmptySection(
                icon: Icon(Icons.favorite),
                title: Text(
                  "No favorites yet",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Add your favorite topics to continue practicing",
                  softWrap: true,
                ),
                backgroundColor: AppColors.white,
                borderColor: AppColors.favoriteLight,
                iconColor: AppColors.favoriteContainer,
              )
            else
              Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 180,
                  child: Skeletonizer(
                    enabled: state.requestStatus == RequestStatus.loading,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.data?.length ?? 0,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        return TopicCard(dialog: state.data?[index]);
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
