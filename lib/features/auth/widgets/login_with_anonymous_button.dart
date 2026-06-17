import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/blocs/user/get-profile/user_profile_get_bloc.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/l10n/l10n.dart';

class LoginWithAnonymousButton extends StatefulWidget {
  const LoginWithAnonymousButton({super.key});

  @override
  State<LoginWithAnonymousButton> createState() =>
      _LoginWithAnonymousButtonState();
}

class _LoginWithAnonymousButtonState extends State<LoginWithAnonymousButton> {
  UserProfileGetBloc get _userProfileGetBloc =>
      context.read<UserProfileGetBloc>();
  bool _pending = false;

  void _loginWithAnonymous() {
    setState(() => _pending = true);
    context.read<AuthBloc>().add(AuthLoginWithAnonymous());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!_pending) return;
        if (state.requestStatus != RequestStatus.success) return;
        if (state.user == null || state.data == null) return;

        setState(() => _pending = false);
        // No profile yet → onboarding; otherwise the redirect handles /home.
        if (_userProfileGetBloc.state.data == null) {
          context.go('/onboarding');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state.requestStatus == RequestStatus.loading;
          return OutlinedButton(
            onPressed: isLoading ? null : _loginWithAnonymous,
            child: Text(context.l10n.startNow),
          );
        },
      ),
    );
  }
}
