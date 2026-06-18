import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/blocs/locale/locale_cubit.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_event.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_state.dart';
import 'package:zingo/config/app_theme.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/l10n/app_localizations.dart';
import 'package:zingo/routes/init.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SharedPreferences.getInstance(), // warm up before runApp
  ]);
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
  late final LocaleCubit _localeCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
    _speechToTextBloc = SpeechToTextBloc()
      ..add(const SpeechToTextInitializeEvent());
    _userConfigurationBloc = UserConfigurationGetBloc();
    _localeCubit = LocaleCubit();
    _router = buildRoutes(
      authBloc: _authBloc,
      userConfigurationGetBloc: _userConfigurationBloc,
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    _speechToTextBloc.close();
    _userConfigurationBloc.close();
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
        BlocProvider.value(value: _localeCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          // Trigger configuration fetch when auth succeeds
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.requestStatus == RequestStatus.success &&
                  state.data != null) {
                _userConfigurationBloc.add(
                  UserConfigurationGetFetched(userId: state.data!.id),
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
