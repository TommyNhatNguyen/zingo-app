import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/blocs/locale/locale_cubit.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_event.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_state.dart';
import 'package:zingo/blocs/user/get-streak/user_streak_get_bloc.dart';
import 'package:zingo/blocs/user/get-streak/user_streak_get_event.dart';
import 'package:zingo/config/app_theme.dart';
import 'package:zingo/config/dio_http.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/l10n/app_localizations.dart';
import 'package:zingo/routes/init.dart';
import 'package:zingo/ver_2/data/model/api_error.dart';
import 'package:zingo/ver_2/data/model/result.dart';

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

class _MainAppState extends State<MainApp> {
  late final AuthBloc _authBloc;
  late final SpeechToTextBloc _speechToTextBloc;
  late final UserConfigurationGetBloc _userConfigurationBloc;
  late final UserStreakGetBloc _userStreakGetBloc;
  late final LocaleCubit _localeCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
    _speechToTextBloc = SpeechToTextBloc()
      ..add(const SpeechToTextInitializeEvent());
    _userConfigurationBloc = UserConfigurationGetBloc();
    _userStreakGetBloc = UserStreakGetBloc();
    _localeCubit = LocaleCubit();
    _router = buildRoutes(
      authBloc: _authBloc,
      userConfigurationGetBloc: _userConfigurationBloc,
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
      ],
      child: MultiBlocListener(
        listeners: [
          // Trigger configuration fetch when auth succeeds
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
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
            );
          },
        ),
      ),
    );
  }
}
