import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_bloc.dart';
import 'package:zingo/core/blocs/dialog/get-dialog-turns/dialog_turns_list_by_dialog_event.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/core/blocs/dialog/recent/recent_dialogs_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/complete-practice/complete_practice_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_bloc.dart';
import 'package:zingo/core/blocs/practice-sessions/start-practice/start_practice_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_event.dart';
import 'package:zingo/core/blocs/recommendations/list/recommendations_list_bloc.dart';
import 'package:zingo/core/blocs/user/get/users_bloc.dart';
import 'package:zingo/core/blocs/user/list-favorite-dialogs/list_favorite_dialogs_bloc.dart';
import 'package:zingo/core/blocs/user/update-configuration/user_configuration_update_bloc.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/domain/dtos/journey/journey_payload.dart';
import 'package:zingo/domain/models/completed_practice_session.dart';
import 'package:zingo/domain/models/dialog.dart';
import 'package:zingo/routing/redirect-handler.dart';
import 'package:zingo/ui/auth/login/widgets/login_screen.dart';
import 'package:zingo/ui/auth/register/widgets/register_screen.dart';
import 'package:zingo/ui/congrats/widgets/streak_congrats_screen.dart';
import 'package:zingo/ui/core/ui/app_shell.dart';
import 'package:zingo/ui/core/ui/test_screen.dart';
import 'package:zingo/ui/explore-detail/widgets/learn_detail_screen.dart';
import 'package:zingo/ui/explore/widgets/learn_screen.dart';
import 'package:zingo/ui/home/widgets/home_screen.dart';
import 'package:zingo/ui/onboarding/widgets/onboarding_screen.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_bloc.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/ui/practice/widgets/practice_screen.dart';
import 'package:zingo/ui/profile-setting/widgets/user_profile_anonymous_screen.dart';
import 'package:zingo/ui/profile-setting/widgets/user_profile_screen.dart';
import 'package:zingo/ui/splash/splash_screen.dart';
import 'package:zingo/ui/user-setting/widgets/user_setting_screen.dart';
import 'package:zingo/ui/welcome/widgets/welcome_screen.dart';

Page<dynamic> _noTransitionPage(LocalKey key, Widget child) =>
    NoTransitionPage(key: key, child: child);

Page<dynamic> _fadePage(LocalKey key, Widget child) => CustomTransitionPage(
  key: key,
  child: child,
  transitionDuration: const Duration(milliseconds: 300),
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: child,
      ),
);

Page<dynamic> _slidePage(LocalKey key, Widget child) => CustomTransitionPage(
  key: key,
  child: child,
  transitionDuration: const Duration(milliseconds: 300),
  reverseTransitionDuration: const Duration(milliseconds: 250),
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            ),
        child: child,
      ),
);

GoRouter buildRoutes({Listenable? refreshListenable}) => GoRouter(
  // initialLocation: '/onboarding',
  // initialLocation: '/learn',
  // initialLocation: '/streak-congrats',
  // initialLocation: '/learn/13febbdf-a74c-4904-bc3b-c22bdec6a327',
  // initialLocation: '/practice',
  // initialLocation: '/profile',
  // initialLocation: '/welcome',
  initialLocation: '/splash',
  // initialLocation: "/home",
  refreshListenable: refreshListenable,
  redirect: (context, state) => RedirectHandler.redirectHandler(context, state),

  // redirect: (context, state) {
  //   final authState = context.read<AuthBloc>().state;
  //   final profile = context
  //       .read<UserConfigurationGetBloc>()
  //       .state
  //       .data
  //       ?.profile;
  //   final location = state.matchedLocation;
  //   print("User: ${authState.user}");
  //   print("Profile: ${profile}");
  //   // Wait for the auth check to finish before redirecting.
  //   if (authState.requestStatus == RequestStatus.initial ||
  //       authState.requestStatus == RequestStatus.loading) {
  //     return null;
  //   }

  //   final isLoggedIn = authState.user != null;
  //   final hasProfile = profile != null;
  //   final isPublicRoute = const [
  //     '/welcome',
  //     '/login',
  //     '/register',
  //     '/splash',
  //   ].contains(location);
  //   final isAnonymous = authState.user?.isAnonymous ?? true;
  //   final isOnboardingRoute = location == '/onboarding';

  //   if (!isLoggedIn) {
  //     return isPublicRoute ? null : '/welcome';
  //   }

  //   // Logged in but no profile yet.
  //   if (!hasProfile) {
  //     if (isOnboardingRoute) return null;
  //     if (isAnonymous) return null;
  //     if (!isPublicRoute) return '/welcome';
  //     // Non-anonymous user on a public route: wait for config to confirm no
  //     // profile before sending to onboarding (avoids redirect before fetch).
  //     final configStatus = context
  //         .read<UserConfigurationGetBloc>()
  //         .state
  //         .requestStatus;
  //     if (configStatus == RequestStatus.success) return '/onboarding';
  //     return null;
  //   }

  //   // Logged in with profile — redirect public routes and onboarding to home.
  //   if (isOnboardingRoute) return '/home';
  //   return isPublicRoute
  //       ? isAnonymous
  //             ? '/welcome'
  //             : '/home'
  //       : null;
  // },
  routes: [
    GoRoute(path: '/test', builder: (context, state) => TestScreen()),
    GoRoute(
      path: '/practice',
      builder: (context, state) {
        final practiceSessionId =
            (state.extra as Map<String, dynamic>?)?['practice_session_id'];
        final dialogId = (state.extra as Map<String, dynamic>?)?['dialog_id'];
        final praceticeMode =
            (state.extra as Map<String, dynamic>?)?['pracetice_mode']
                as PracticeMode?;
        final dialog =
            (state.extra as Map<String, dynamic>?)?['dialog'] as Dialog?;
        return MultiBlocProvider(
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
        );
      },
    ),
    GoRoute(
      path: '/streak-congrats',
      builder: (context, state) {
        final session =
            (state.extra as Map<String, dynamic>?)?['session']
                as CompletedPracticeSession?;
        return StreakCongratsScreen(session: session);
      },
    ),
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) =>
          _noTransitionPage(state.pageKey, const SplashScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          _fadePage(state.pageKey, const OnboardingScreen()),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) =>
          _noTransitionPage(state.pageKey, const WelcomeScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          _noTransitionPage(state.pageKey, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => _noTransitionPage(
        state.pageKey,
        BlocProvider(create: (_) => UsersBloc(), child: const RegisterScreen()),
      ),
    ),
    // ── Main tabs (with bottom nav) ──────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) =>
          _fadePage(state.pageKey, AppShell(navigationShell: navigationShell)),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => BlocProvider(
                create: (context) => JourneyBloc()
                  ..add(
                    JourneyFetchEvent(
                      payload: JourneyPayload(
                        user_id: context.read<AuthBloc>().state.data?.id ?? '',
                      ),
                    ),
                  ),
                child: const HomeScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learn',
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => DialogListBloc()),
                  BlocProvider(create: (_) => ListActiveDialogsBloc()),
                  BlocProvider(create: (_) => ListFavoriteDialogsBloc()),
                  BlocProvider(create: (_) => RecommendationsListBloc()),
                  BlocProvider(create: (_) => RecentDialogsBloc()),
                ],
                child: const LearnScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                final authUserData = context.read<AuthBloc>().state.user;
                final isAnonymous = authUserData?.isAnonymous ?? true;
                return isAnonymous
                    ? const UserProfileAnonymousScreen()
                    : BlocProvider(
                        create: (_) => UserConfigurationUpdateBloc(),
                        child: const UserProfileScreen(),
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
          child: const UserSettingScreen(),
        );
      },
    ),
  ],
);
