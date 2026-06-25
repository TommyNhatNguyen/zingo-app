import 'package:go_router/go_router.dart';
import 'package:zingo/routing/home_route.dart';
import 'package:zingo/routing/learn_route.dart';
import 'package:zingo/routing/profile_route.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/core/ui/app_shell.dart';

class AppShellRoute {
  static StatefulShellRoute buildRoute() => StatefulShellRoute.indexedStack(
    pageBuilder: (context, state, navigationShell) => RoutePageBuilders.fade(
      state.pageKey,
      AppShell(navigationShell: navigationShell),
    ),
    branches: [
      StatefulShellBranch(routes: [HomeRoute.buildRoute()]),
      StatefulShellBranch(routes: [LearnRoute.buildRoute()]),
      StatefulShellBranch(routes: [ProfileRoute.buildRoute()]),
    ],
  );
}
