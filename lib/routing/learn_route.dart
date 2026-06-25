import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/core/blocs/dialog/recent/recent_dialogs_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_bloc.dart';
import 'package:zingo/core/blocs/recommendations/list/recommendations_list_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_bloc.dart';
import 'package:zingo/ui/explore/widgets/learn_screen.dart';

class LearnRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/learn',
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DialogListBloc()),
        BlocProvider(create: (_) => ListActiveDialogsBloc()),
        BlocProvider(create: (_) => ListFavoriteDialogsBloc()),
        BlocProvider(create: (_) => RecommendationsListBloc()),
        BlocProvider(create: (_) => RecentDialogsBloc()),
      ],
      child: const LearnScreen(),
    ),
  );
}
