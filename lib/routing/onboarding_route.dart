import 'package:go_router/go_router.dart';
import 'package:zingo/routing/route_page_builders.dart';
import 'package:zingo/ui/onboarding/widgets/onboarding_screen.dart';

class OnboardingRoute {
  static GoRoute buildRoute() => GoRoute(
    path: '/onboarding',
    pageBuilder: (context, state) =>
        RoutePageBuilders.fade(state.pageKey, const OnboardingScreen()),
  );
}
