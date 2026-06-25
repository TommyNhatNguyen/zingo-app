import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_bloc.dart';
import 'package:zingo/ui/explore-detail/widgets/learn_detail_screen.dart';

class LearnDetailRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/learn/:id',
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DialogDetailBloc()),
          BlocProvider(create: (_) => StartPracticeBloc()),
        ],
        child: LearnDetailScreen(id: id),
      );
    },
  );
}
