import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/core/blocs/dialog/popular/popular_dialogs_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_bloc.dart';
import 'package:zingo/core/blocs/recommendations/list/recommendations_list_bloc.dart';
import 'package:zingo/routing/learn_detail_route.dart';
import 'package:zingo/ui/explore/widgets/learn_screen.dart';

class LearnRoute {
  static ShellRoute buildRoute() => ShellRoute(
    builder: (context, state, child) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DialogListBloc()),
        BlocProvider(create: (_) => ListActiveDialogsBloc()),
        BlocProvider(create: (_) => RecommendationsListBloc()),
        BlocProvider(create: (_) => PopularDialogsBloc()),
      ],
      child: child,
    ),
    routes: [
      GoRoute(
        path: '/learn',
        builder: (context, state) => const LearnScreen(),
        routes: [LearnDetailRoute.buildRoute()],
      ),
    ],
  );
}
