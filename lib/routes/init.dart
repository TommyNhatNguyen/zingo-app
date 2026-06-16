import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/blocs/dialog-turns/list-by-dialog/dialog_turns_list_by_dialog_event.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/blocs/journey/journey_bloc.dart';
import 'package:zingo/blocs/journey/journey_event.dart';
import 'package:zingo/blocs/practice-sessions/complete-practice/complete_practice_bloc.dart';
import 'package:zingo/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_bloc.dart';
import 'package:zingo/blocs/practice-sessions/start-practice/start_practice_bloc.dart';
import 'package:zingo/blocs/recommendations/list/recommendations_list_bloc.dart';
import 'package:zingo/blocs/user-favorite-dialogs/list/list_favorite_dialogs_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_event.dart';
import 'package:zingo/blocs/users/get/users_bloc.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/models/completed_practice_session.dart';
import 'package:zingo/models/dialog.dart';
import 'package:zingo/screens/auth/login_screen.dart';
import 'package:zingo/screens/auth/register_screen.dart';
import 'package:zingo/screens/auth/welcome_screen.dart';
import 'package:zingo/screens/congrats/streak_congrats_screen.dart';
import 'package:zingo/screens/home/home_screen.dart';
import 'package:zingo/screens/learn/learn-detail/learn_detail_screen.dart';
import 'package:zingo/screens/learn/learn_screen.dart';
import 'package:zingo/screens/onboarding/onboarding_screen.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_bloc.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/screens/practice/practice_screen.dart';
import 'package:zingo/screens/settings/setting_screen.dart';
import 'package:zingo/screens/shell/app_shell.dart';
import 'package:zingo/screens/splash/splash_screen.dart';
import 'package:zingo/screens/test/test_screen.dart';
import 'package:zingo/screens/users/user_profile_anonymous_screen.dart';
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
  // initialLocation: '/onboarding',
  // initialLocation: '/learn',
  // initialLocation: '/streak-congrats',
  // initialLocation: '/learn/13febbdf-a74c-4904-bc3b-c22bdec6a327',
  // initialLocation: '/practice',
  // initialLocation: '/profile',
  initialLocation: '/welcome',
  // initialLocation: "/home",
  refreshListenable: GoRouterRefreshStream(authBloc.stream),
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final location = state.matchedLocation;
    print("User: ${authState.user}");
    print("Profile: ${authState.profile}");
    // Wait for the auth check to finish before redirecting.
    if (authState.requestStatus == RequestStatus.initial ||
        authState.requestStatus == RequestStatus.loading) {
      return null;
    }

    final isLoggedIn = authState.user != null;
    final hasProfile = authState.profile != null;
    final isPublicRoute = const [
      '/welcome',
      '/login',
      '/register',
      '/splash',
    ].contains(location);
    final isOnboardingRoute = location == '/onboarding';
    final isProfileRoute = location == '/profile';
    final isSettingRoute = location == '/setting';

    if (!isLoggedIn) {
      return isPublicRoute ? null : '/welcome';
    }

    // Logged in but no profile yet — allow welcome + onboarding only.
    if (!hasProfile) {
      if (isPublicRoute || isOnboardingRoute) return null;
      return '/welcome';
    }

    // Logged in with profile — leave protected routes alone, redirect public to home.
    return isPublicRoute ? '/profile' : null;
  },
  routes: [
    GoRoute(
      path: '/test',
      pageBuilder: (context, state) {
        return NoTransitionPage(key: state.pageKey, child: TestScreen());
      },
    ),
    GoRoute(
      path: '/practice',
      pageBuilder: (context, state) {
        final practiceSessionId =
            (state.extra as Map<String, dynamic>?)?['practice_session_id'];
        final dialogId = (state.extra as Map<String, dynamic>?)?['dialog_id'];
        final praceticeMode =
            (state.extra as Map<String, dynamic>?)?['pracetice_mode']
                as PracticeMode?;
        final dialog =
            (state.extra as Map<String, dynamic>?)?['dialog'] as Dialog?;
        return NoTransitionPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => DialogTurnsListByDialogBloc()
                  ..add(
                    DialogTurnsListByDialogFetchEvent(
                      payload: DialogTurnsByDialogIdPayload(
                        dialogId:
                            dialogId ?? '13febbdf-a74c-4904-bc3b-c22bdec6a327',
                      ),
                    ),
                  ),
              ),
              BlocProvider(
                create: (context) =>
                    PracticeScreenBloc()..add(PracticeScreenInitializeEvent()),
              ),
              BlocProvider(create: (_) => CompletePracticeBloc()),
            ],
            child: PracticeScreen(
              practiceSessionId: practiceSessionId ?? '',
              dialogId: dialogId ?? '',
              practiceMode: praceticeMode ?? PracticeMode.readAloud,
              dialog: dialog,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/streak-congrats',
      pageBuilder: (context, state) {
        final session =
            (state.extra as Map<String, dynamic>?)?['session']
                as CompletedPracticeSession?;
        return NoTransitionPage(
          key: state.pageKey,
          child: StreakCongratsScreen(session: session),
        );
      },
    ),
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
      path: '/welcome',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: const WelcomeScreen(),
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
    // ── Main tabs (with bottom nav) ──────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) =>
                        JourneyBloc()..add(const JourneyFetchEvent()),
                    child: const HomeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learn',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => DialogListBloc()),
                      BlocProvider(create: (_) => ListActiveDialogsBloc()),
                      BlocProvider(create: (_) => ListFavoriteDialogsBloc()),
                      BlocProvider(create: (_) => RecommendationsListBloc()),
                    ],
                    child: const LearnScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) {
                final authData = context.read<AuthBloc>().state.data;
                final authUserData = context.read<AuthBloc>().state.user;
                final isAnonymous = authUserData?.isAnonymous ?? true;
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
                    child: isAnonymous
                        ? const UserProfileAnonymousScreen()
                        : const UserProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
    // ── Full-screen (no bottom nav) ──────────────────────────────────────────
    GoRoute(
      path: '/learn/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DialogDetailBloc()),
            BlocProvider(create: (_) => StartPracticeBloc()),
          ],
          child: LearnDetailScreen(id: id),
        );
      },
    ),
    GoRoute(
      path: '/setting',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          key: state.pageKey,
          child: const SettingScreen(),
        );
      },
    ),
  ],
);
