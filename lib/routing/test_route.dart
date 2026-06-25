import 'package:go_router/go_router.dart';
import 'package:zingo/ui/core/ui/test_screen.dart';

class TestRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/test',
    builder: (context, state) => TestScreen(),
  );
}
