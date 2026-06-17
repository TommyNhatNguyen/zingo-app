import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/l10n/l10n.dart';

class LoginWithGoogleButton extends StatefulWidget {
  const LoginWithGoogleButton({super.key});

  @override
  State<LoginWithGoogleButton> createState() => _LoginWithGoogleButtonState();
}

class _LoginWithGoogleButtonState extends State<LoginWithGoogleButton> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
  }

  void _loginWithGoogle(BuildContext context) {
    _authBloc.add(AuthLoginWithGoogle());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;
        return OutlinedButton.icon(
          onPressed: isLoading ? null : () => _loginWithGoogle(context),
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
    );
  }
}
