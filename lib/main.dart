import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_event.dart';
import 'package:zingo/blocs/user-profile/get/user_profile_get_bloc.dart';
import 'package:zingo/blocs/user-profile/get/user_profile_get_event.dart';
import 'package:zingo/blocs/user-settings/get/user_settings_get_bloc.dart';
import 'package:zingo/blocs/user-settings/get/user_settings_get_event.dart';
import 'package:zingo/config/app_theme.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/routes/init.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  late final UserSettingsGetBloc _userSettingBloc;
  late final UserProfileGetBloc _userProfileGetBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
    _speechToTextBloc = SpeechToTextBloc()
      ..add(const SpeechToTextInitializeEvent());
    _userSettingBloc = UserSettingsGetBloc();
    _userProfileGetBloc = UserProfileGetBloc();
  }

  @override
  void dispose() {
    _authBloc.close();
    _speechToTextBloc.close();
    _userSettingBloc.close();
    _userProfileGetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _speechToTextBloc),
        BlocProvider.value(value: _userSettingBloc),
        BlocProvider.value(value: _userProfileGetBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.requestStatus == RequestStatus.success &&
                  state.data != null) {
                _userSettingBloc.add(
                  UserSettingsGetFetched(userId: state.data!.id),
                );
                _userProfileGetBloc.add(
                  UserProfileGetFetched(userId: state.data!.id),
                );
              }
            },
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: buildRoutes(_authBloc),
        ),
      ),
    );
  }
}
