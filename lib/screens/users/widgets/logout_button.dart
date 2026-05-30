import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, this.disabled = false});
  final bool disabled;

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLoggedOut());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: disabled ? null : () => _logout(context),
        icon: const Icon(Icons.logout),
        label: Text('Log out'),
      ),
    );
  }
}
