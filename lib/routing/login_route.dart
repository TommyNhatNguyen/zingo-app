import 'package:go_router/go_router.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/auth/login/widgets/login_screen.dart';

class LoginRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/login',
    pageBuilder: (context, state) =>
        RoutePageBuilders.noTransition(state.pageKey, const LoginScreen()),
  );
}
