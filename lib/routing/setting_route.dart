import 'package:go_router/go_router.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/user-setting/widgets/user_setting_screen.dart';

class SettingRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/setting',
    pageBuilder: (context, state) => RoutePageBuilders.slideFromBottom(
      state.pageKey,
      const UserSettingScreen(),
    ),
  );
}
