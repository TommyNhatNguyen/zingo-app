import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_bloc.dart';
import 'package:zingo/core/blocs/user/update-favorite-dialog/update_favorite_dialog_bloc.dart';
import 'package:zingo/routing/router_keys.dart';
import 'package:zingo/ui/explore-detail/widgets/learn_detail_screen.dart';

class LearnDetailRoute {
  static GoRoute buildRoute() => GoRoute(
    path: ':id',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DialogDetailBloc()),
          BlocProvider(create: (_) => StartPracticeBloc()),
          BlocProvider(create: (_) => FavoriteDialogBloc()),
        ],
        child: LearnDetailScreen(id: id),
      );
    },
  );
}
