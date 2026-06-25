import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/constants/enums.dart';

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
    final isSplashRoute = curLoc == '/splash';
    // 1. Wait for auth
    final isLoadingAuth = [
      RequestStatus.initial,
      RequestStatus.loading,
    ].contains(authBloc.state.requestStatus);
    final isLoadingConfig = [
      RequestStatus.initial,
      RequestStatus.loading,
    ].contains(userConfigBloc.state.requestStatus);
    if (isLoadingAuth || isLoadingConfig) {
      // if (isSplashRoute) return '/welcome';
      return null;
    }
    ;
    // 2. No auth, public route
    final isAuthenticated = authBloc.state.user != null;
    final hasProfile = userConfigBloc.state.data?.profile != null;
    debugPrint("isAuthenticated: ${isAuthenticated}");
    debugPrint("Has profile: ${hasProfile}");
    if (!isAuthenticated) {
      if (isSplashRoute) return '/welcome';
      return isPublicRoute ? null : '/welcome';
    }
    // 3. Has auth, no profile, public route
    final isAnonymous = authBloc.state.user?.isAnonymous ?? true;
    if (isAuthenticated && !hasProfile) {
      // 3.1 Anonymous auth
      if (isAnonymous) return null;
      // 3.2 Normal auth
      return '/onboarding';
    }
    // 4. Has auth, has profile, public route
    // 4.1 Anonymous path
    if (isAnonymous) {
      return isPublicRoute ? '/welcome' : null;
    }
    return (isPublicRoute || isOnboardingRoute) ? '/home' : null;
  }
}
