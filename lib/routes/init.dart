import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_bloc.dart';
import 'package:zingo/blocs/users/users_bloc.dart';
import 'package:zingo/screens/auth/login_screen.dart';
import 'package:zingo/screens/auth/register_screen.dart';
import 'package:zingo/screens/home/home_screen.dart';
import 'package:zingo/screens/profile/profile_screen.dart';

final initRoutes = GoRouter(
  initialLocation: "/home",
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
        return NoTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        );
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
      builder: (context, state) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }

            if (!snapshot.hasData) {
              return const LoginScreen();
            }

            return const HomeScreen();
          },
        );
      },
    ),
  ],
);
