import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_bloc.dart';
import 'package:zingo/blocs/users/users_bloc.dart';
import 'package:zingo/screens/auth/login_screen.dart';
import 'package:zingo/screens/auth/register_screen.dart';
import 'package:zingo/screens/home/home_screen.dart';
import 'package:zingo/screens/onboarding/onboarding_screen.dart';
import 'package:zingo/screens/splash/splash_screen.dart';
import 'package:zingo/screens/users/user_profile_screen.dart';

final initRoutes = GoRouter(
  initialLocation: '/splash',
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
        return NoTransitionPage(
          key: state.pageKey,
          child: const UserProfileScreen(),
        );
      },
    ),
  ],
);
