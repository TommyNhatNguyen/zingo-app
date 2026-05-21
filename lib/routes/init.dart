import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_event.dart';
import 'package:zingo/blocs/users/get/users_bloc.dart';
import 'package:zingo/screens/auth/login_screen.dart';
import 'package:zingo/screens/auth/register_screen.dart';
import 'package:zingo/screens/home/home_screen.dart';
import 'package:zingo/screens/learn/learn-detail/learn_detail_screen.dart';
import 'package:zingo/screens/learn/learn_screen.dart';
import 'package:zingo/screens/onboarding/onboarding_screen.dart';
import 'package:zingo/screens/splash/splash_screen.dart';
import 'package:zingo/screens/users/user_profile_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter buildRoutes(AuthBloc authBloc) => GoRouter(
  initialLocation: '/learn/ef8f3029-c801-4a6c-b0ff-0c957d736f63',
  // initialLocation: '/learn',
  refreshListenable: GoRouterRefreshStream(authBloc.stream),
  redirect: (context, state) {
    final location = state.matchedLocation;
    final user = context.read<AuthBloc>().state.user;
    final isSplashRoute = location == '/splash';
    final isLoginRoute = location == '/login';
    final isRegisterRoute = location == '/register';

    if (user != null && isSplashRoute) {
      return '/home';
    }

    if (user == null && !(isSplashRoute || isLoginRoute || isRegisterRoute)) {
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
        );
      },
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => UserProfileCreateBloc(),
            child: const OnboardingScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return NoTransitionPage(key: state.pageKey, child: const LoginScreen());
      },
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => UsersBloc(),
            child: const RegisterScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) {
        final authData = context.read<AuthBloc>().state.data;
        return NoTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) {
              final bloc = UserSettingsBloc(seedUser: authData);
              if (authData != null) {
                bloc.add(UserSettingsLoaded(userId: authData.id));
              }
              return bloc;
            },
            child: const UserProfileScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => DialogListBloc(),
            child: const LearnScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/learn/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return BlocProvider(
          create: (_) => DialogDetailBloc(),
          child: LearnDetailScreen(id: id),
        );
      },
    ),
  ],
);
