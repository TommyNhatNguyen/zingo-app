import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_event.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class LoginWithGoogleButton extends StatefulWidget {
  const LoginWithGoogleButton({super.key});

  @override
  State<LoginWithGoogleButton> createState() => _LoginWithGoogleButtonState();
}

class _LoginWithGoogleButtonState extends State<LoginWithGoogleButton> {
  bool _isLoggingIn = false;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
  }

  void _loginWithGoogle(BuildContext context, AuthState state) {
    // Already logged in with a real Google account (not anonymous) — navigate directly.
    if (state.user != null && state.user!.isAnonymous == false) {
      final hasProfile =
          context.read<UserConfigurationGetBloc>().state.data?.profile != null;
      context.go(hasProfile ? '/home' : '/onboarding');
      return;
    }
    setState(() => _isLoggingIn = true);
    _authBloc.add(AuthLoginWithGoogle());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!_isLoggingIn) return;
        if (state.requestStatus == RequestStatus.error) {
          setState(() => _isLoggingIn = false);
        }
        // On success: keep _isLoggingIn true so the spinner stays until the
        // router redirect navigates away and this widget is disposed.
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading =
              state.requestStatus == RequestStatus.loading || _isLoggingIn;
          return OutlinedButton.icon(
            onPressed: isLoading ? null : () => _loginWithGoogle(context, state),
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : SvgPicture.network(
                    "https://upload.wikimedia.org/wikipedia/commons/3/3c/Google_Favicon_2025.svg",
                    fit: BoxFit.contain,
                    width: 24,
                    height: 24,
                  ),
            label: Text(context.l10n.signInWithGoogle),
          );
        },
      ),
    );
  }
}
