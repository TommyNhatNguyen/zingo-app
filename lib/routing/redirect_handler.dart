import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/routing/splash_guard.dart';

class RedirectHandler {
  static FutureOr<String?> redirectHandler(
    BuildContext context,
    GoRouterState state,
  ) {
    final authBloc = context.read<AuthBloc>();
    final userConfigBloc = context.read<UserConfigurationGetBloc>();
    final curLoc = state.matchedLocation;
    final isPublicRoute = const [
      '/welcome',
      '/login',
      '/register',
      '/splash',
    ].contains(curLoc);
    final isOnboardingRoute = curLoc == '/onboarding';
    final isWelcomeRoute = curLoc == '/welcome';
    final isSplashRoute = curLoc == '/splash';
    final isErrorRoute = curLoc == '/error' || curLoc == '/no-connection';
    // 0. Hold on splash until minimum display time has elapsed
    if (isSplashRoute && !SplashGuard.instance.ready) return null;
    // 1. Wait for auth
    final isLoadingAuth = [
      RequestStatus.initial,
      RequestStatus.loading,
    ].contains(authBloc.state.requestStatus);
    final isLoadingConfig = [
      RequestStatus.initial,
      RequestStatus.loading,
    ].contains(userConfigBloc.state.requestStatus);

    final isError =
        authBloc.state.requestStatus == RequestStatus.error ||
        userConfigBloc.state.requestStatus == RequestStatus.error;

    if (isError) {
      return '/error';
    }

    if (isLoadingAuth || isLoadingConfig) {
      return null;
    }
    // 2. No auth, public route
    final isAuthenticated = authBloc.state.user != null;
    final hasProfile = userConfigBloc.state.data?.profile != null;
    debugPrint("isAuthenticated: $isAuthenticated");
    debugPrint("Has profile: $hasProfile");
    if (!isAuthenticated) {
      if (isSplashRoute || isErrorRoute) return '/welcome';
      return isPublicRoute ? null : '/welcome';
    }
    // 3. Has auth, no profile, public route
    final isAnonymous = authBloc.state.user?.isAnonymous ?? true;
    if (isAuthenticated && !hasProfile) {
      // 3.1 Anonymous auth
      if (isAnonymous) {
        if (isPublicRoute) {
          return isSplashRoute ? '/welcome' : null;
        }
        return '/onboarding';
      }
      // 3.2 Normal auth
      return '/onboarding';
    }
    // 4. Has auth, has profile, public route
    // 4.1 Anonymous path
    if (isAnonymous) {
      if (isSplashRoute) return '/welcome';
      if (isWelcomeRoute) return '/welcome';
      if (isOnboardingRoute) return '/home';
      return null;
    }
    return (isPublicRoute || isOnboardingRoute || isErrorRoute)
        ? '/home'
        : null;
  }
}
