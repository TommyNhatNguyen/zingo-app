import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/constants/enums.dart';

class LoginWithAnonymousButton extends StatefulWidget {
  const LoginWithAnonymousButton({super.key});

  @override
  State<LoginWithAnonymousButton> createState() =>
      _LoginWithAnonymousButtonState();
}

class _LoginWithAnonymousButtonState extends State<LoginWithAnonymousButton> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
  }

  void _loginWithAnonymous(BuildContext context) {
    _authBloc.add(AuthLoginWithAnonymous());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;
        return OutlinedButton(
          onPressed: isLoading ? null : () => _loginWithAnonymous(context),
          child: const Text("START NOW AS GUEST"),
        );
      },
    );
  }
}
