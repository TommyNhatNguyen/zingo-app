import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_event.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';

class LoginWithAnonymousButton extends StatefulWidget {
  const LoginWithAnonymousButton({super.key});

  @override
  State<LoginWithAnonymousButton> createState() =>
      _LoginWithAnonymousButtonState();
}

class _LoginWithAnonymousButtonState extends State<LoginWithAnonymousButton> {
  bool _isLoggingIn = false;

  UserConfigurationGetBloc get _userConfigurationBloc =>
      context.read<UserConfigurationGetBloc>();
  bool get hasProfile => _userConfigurationBloc.state.data?.profile != null;

  void _loginWithAnonymous(AuthState state) {
    if (state.user != null && !hasProfile) {
      context.go('/onboarding');
      return;
    }
    if (state.user != null && hasProfile) {
      context.go('/home');
      return;
    }
    setState(() => _isLoggingIn = true);
    context.read<AuthBloc>().add(AuthLoginWithAnonymous());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!_isLoggingIn) return;
        if (state.requestStatus == RequestStatus.error) {
          setState(() => _isLoggingIn = false);
          return;
        }
        if (state.requestStatus == RequestStatus.success &&
            state.user != null &&
            (state.user?.isAnonymous ?? true) &&
            !hasProfile) {
          setState(() => _isLoggingIn = false);
          context.go('/onboarding');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state.requestStatus == RequestStatus.loading;
          return OutlinedButton(
            onPressed: isLoading ? null : () => _loginWithAnonymous(state),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.startNow),
          );
        },
      ),
    );
  }
}
