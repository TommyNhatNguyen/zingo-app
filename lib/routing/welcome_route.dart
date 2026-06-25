import 'package:go_router/go_router.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/welcome/widgets/welcome_screen.dart';

class WelcomeRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/welcome',
    pageBuilder: (context, state) =>
        RoutePageBuilders.noTransition(state.pageKey, const WelcomeScreen()),
  );
}
