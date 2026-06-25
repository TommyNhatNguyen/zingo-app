import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/blocs/locale/locale_cubit.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_event.dart';
import 'package:zingo/core/blocs/user/create-profile/user_profile_create_bloc.dart';
import 'package:zingo/core/blocs/user/create-profile/user_profile_create_state.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_state.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_event.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/app_localizations.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/repositories/auth_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/data/services/firebase_auth_service.dart';
import 'package:zingo/domain/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/routing/init.dart';
import 'package:zingo/routing/splash_guard.dart';
import 'package:zingo/ui/core/themes/app_theme.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SharedPreferences.getInstance(), // warm up before runApp
  ]);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final [_, settings as NotificationSettings] = await Future.wait([
    GoogleSignIn.instance.initialize(),
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    ),
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // APNS may not be available (missing entitlement, simulator, etc.) — never block startup.
  try {
    final token = await messaging.getToken();
    print("FCM Token: $token");
  } catch (_) {}

  print("Notification Authorization Status: ${settings.authorizationStatus}");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class GoRouterRefreshStream extends ChangeNotifier {
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  GoRouterRefreshStream({required Iterable<Stream<dynamic>> streams}) {
    for (final stream in streams) {
      final subscription = stream.listen((data) {
        debugPrint("GoRouterRefreshStream: $data");
        switch (data) {
          case AuthState(:final requestStatus):
            debugPrint("AuthState: $requestStatus");
            if (requestStatus == RequestStatus.success) {
              notifyListeners();
            }
            break;
          case UserConfigurationGetState(:final requestStatus):
            debugPrint("UserConfigurationGetState: $requestStatus");
            if (requestStatus == RequestStatus.success) {
              notifyListeners();
            }
            break;
        }
      });
      _subscriptions.add(subscription);
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}

class _MainAppState extends State<MainApp> {
  late final AuthBloc _authBloc;
  late final SpeechToTextBloc _speechToTextBloc;
  late final UserConfigurationGetBloc _userConfigurationBloc;
  late final UserStreakGetBloc _userStreakGetBloc;
  late final LocaleCubit _localeCubit;
  late final GoRouter _router;
  late final UserProfileCreateBloc _userProfileCreateBloc;
  late final GoRouterRefreshStream _refreshStream;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(
      authRepository: AuthRepository(
        firebaseAuthService: FirebaseAuthService(),
        apiClientService: ApiClientService(httpClient: dio),
      ),
    );
    _speechToTextBloc = SpeechToTextBloc()
      ..add(const SpeechToTextInitializeEvent());
    _userConfigurationBloc = UserConfigurationGetBloc();
    _userStreakGetBloc = UserStreakGetBloc();
    _localeCubit = LocaleCubit();
    _userProfileCreateBloc = UserProfileCreateBloc();
    _refreshStream = GoRouterRefreshStream(
      streams: [_authBloc.stream, _userConfigurationBloc.stream],
    );
    _router = buildRoutes(
      refreshListenable: Listenable.merge([_refreshStream, SplashGuard.instance]),
    );
    setupInteractedMessage();
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    // Handle messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      print('Message data: ${message.data}');
    }
    print('Message data: ${message.data}');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
  }

  @override
  void dispose() {
    _authBloc.close();
    _speechToTextBloc.close();
    _userConfigurationBloc.close();
    _userStreakGetBloc.close();
    _localeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _speechToTextBloc),
        BlocProvider.value(value: _userConfigurationBloc),
        BlocProvider.value(value: _userStreakGetBloc),
        BlocProvider.value(value: _localeCubit),
        BlocProvider.value(value: _userProfileCreateBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          // Trigger configuration fetch when auth succeeds
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.requestStatus == RequestStatus.success &&
                  state.user == null) {
                _userConfigurationBloc.add(const UserConfigurationGetReset());
                return;
              }
              if (state.requestStatus == RequestStatus.success &&
                  state.data != null) {
                final userId = state.data!.id;
                _userConfigurationBloc.add(
                  UserConfigurationGetFetched(userId: userId),
                );
                _userStreakGetBloc.add(
                  UserStreakGetFetched(
                    payload: GetUserStreakPayload(
                      user_id: userId,
                      year: DateTime.now().year,
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<UserProfileCreateBloc, UserProfileCreateState>(
            listener: (context, state) {
              if (state.requestStatus == RequestStatus.success &&
                  state.data != null) {
                final userId = state.data!.user_id;
                // Immediately update profile so the router can redirect to /home
                // without waiting for the network round-trip.
                _userConfigurationBloc.add(
                  UserConfigurationGetProfileUpdated(profile: state.data!),
                );
                // Fetch full config in the background to populate settings.
                _userConfigurationBloc.add(
                  UserConfigurationGetFetched(userId: userId),
                );
                _userStreakGetBloc.add(
                  UserStreakGetFetched(
                    payload: GetUserStreakPayload(
                      user_id: userId,
                      year: DateTime.now().year,
                    ),
                  ),
                );
              }
            },
          ),
          // Sync backend display_language into LocaleCubit on successful fetch
          BlocListener<UserConfigurationGetBloc, UserConfigurationGetState>(
            listenWhen: (prev, curr) =>
                curr.requestStatus == RequestStatus.success &&
                prev.requestStatus != RequestStatus.success,
            listener: (context, state) {
              final code = state.data?.settings?.display_language;
              if (code != null) {
                context.read<LocaleCubit>().setLocale(code);
              }
            },
          ),
        ],
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              theme: AppTheme.light,
              routerConfig: _router,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: child,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
