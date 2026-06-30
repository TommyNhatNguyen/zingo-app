import 'package:go_router/go_router.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/error/widgets/error_screen.dart';

class ErrorRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/error',
    pageBuilder: (context, state) =>
        RoutePageBuilders.noTransition(state.pageKey, ErrorScreen()),
  );
}
