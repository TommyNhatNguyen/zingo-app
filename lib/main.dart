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
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/l10n/app_localizations.dart';
import 'package:zingo/routes/init.dart';

import 'firebase_options.dart';

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
  await GoogleSignIn.instance.initialize();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  print("token : ${token}");
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print("settings : ${settings}");

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    await _firebaseMessagingBackgroundHandler(message);
  });

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

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print('Initial message: ${message.data}');
        if (message.notification != null) {
          print('Initial message notification: ${message.notification?.title}');
          print('Initial message notification: ${message.notification?.body}');
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification?.title}',
        );
        print(
          'Message also contained a notification: ${message.notification?.body}',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.data}');
    });
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
                    userId: userId,
                    payload: GetUserStreakPayload(year: DateTime.now().year),
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
