import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_bloc.dart';
import 'package:zingo/blocs/users/users_bloc.dart';
import 'package:zingo/screens/auth/login_screen.dart';
import 'package:zingo/screens/auth/register_screen.dart';
import 'package:zingo/screens/home/home_screen.dart';
import 'package:zingo/screens/profile/profile_screen.dart';

final initRoutes = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    final location = state.matchedLocation;
    final user = context.read<AuthBloc>().state.user;
    final isLoginRoute = location == '/login';
    final isRegisterRoute = location == '/register';

    if (user == null && !(isLoginRoute || isRegisterRoute)) {
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => UserProfileCreateBloc(),
            child: const ProfileScreen(),
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
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ],
);
