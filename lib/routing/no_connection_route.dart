import 'package:go_router/go_router.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/error/widgets/no_connection_screen.dart';

class NoConnectionRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/no-connection',
    pageBuilder: (context, state) => RoutePageBuilders.noTransition(
      state.pageKey,
      const NoConnectionScreen(),
    ),
  );
}
