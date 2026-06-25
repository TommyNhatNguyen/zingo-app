import 'package:go_router/go_router.dart';
import 'package:zingo/domain/models/completed_practice_session.dart';
import 'package:zingo/ui/congrats/widgets/streak_congrats_screen.dart';

class StreakCongratsRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/streak-congrats',
    builder: (context, state) {
      final session =
          (state.extra as Map<String, dynamic>?)?['session']
              as CompletedPracticeSession?;
      return StreakCongratsScreen(session: session);
    },
  );
}
