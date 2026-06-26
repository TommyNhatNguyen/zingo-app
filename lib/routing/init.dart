import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/routing/app_shell_route.dart';
import 'package:zingo/routing/error_route.dart';
import 'package:zingo/routing/learn_detail_route.dart';
import 'package:zingo/routing/login_route.dart';
import 'package:zingo/routing/no_connection_route.dart';
import 'package:zingo/routing/onboarding_route.dart';
import 'package:zingo/routing/practice_route.dart';
import 'package:zingo/routing/redirect_handler.dart';
import 'package:zingo/routing/register_route.dart';
import 'package:zingo/routing/setting_route.dart';
import 'package:zingo/routing/splash_route.dart';
import 'package:zingo/routing/streak_congrats_route.dart';
import 'package:zingo/routing/test_route.dart';
import 'package:zingo/routing/welcome_route.dart';
import 'package:zingo/ui/core/ui/connection_shell.dart';

GoRouter buildRoutes({Listenable? refreshListenable}) => GoRouter(
  initialLocation: '/splash',
  refreshListenable: refreshListenable,
  redirect: (context, state) => RedirectHandler.redirectHandler(context, state),
  routes: [
    ShellRoute(
      builder: (context, state, child) => ConnectionShell(child: child),
      routes: [
        TestRoute.buildRoute(),
        PracticeRoute.buildRoute(),
        StreakCongratsRoute.buildRoute(),
        SplashRoute.buildRoute(),
        OnboardingRoute.buildRoute(),
        WelcomeRoute.buildRoute(),
        LoginRoute.buildRoute(),
        RegisterRoute.buildRoute(),
        AppShellRoute.buildRoute(),
        LearnDetailRoute.buildRoute(),
        SettingRoute.buildRoute(),
        ErrorRoute.buildRoute(),
        NoConnectionRoute.buildRoute(),
      ],
    ),
  ],
);
