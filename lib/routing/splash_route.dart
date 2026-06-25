import 'package:go_router/go_router.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/splash/splash_screen.dart';

class SplashRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/splash',
    pageBuilder: (context, state) =>
        RoutePageBuilders.fade(state.pageKey, const SplashScreen()),
  );
}
