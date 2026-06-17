import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/features/auth/widgets/login_with_anonymous_button.dart';
import 'package:zingo/features/auth/widgets/logo_info.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              const LogoInfo(),
              const Spacer(flex: 4),
              const LoginWithAnonymousButton(),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push('/login'),
                child: const Text("I already have an account"),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
