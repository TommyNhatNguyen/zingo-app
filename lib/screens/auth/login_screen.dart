import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/auth/login_dto.dart';
import 'package:zingo/screens/auth/widgets/auth_divider.dart';
import 'package:zingo/screens/auth/widgets/login_with_anonymous_button.dart';
import 'package:zingo/screens/auth/widgets/login_with_google_button.dart';
import 'package:zingo/screens/auth/widgets/logo_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isShowPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    context.read<AuthBloc>().add(
      AuthLoginWithEmailAndPassword(
        payload: LoginDto(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current.requestStatus == RequestStatus.success &&
          current.data != null &&
          previous.requestStatus != RequestStatus.success,
      listener: (context, state) {
        if (state.data != null &&
            state.requestStatus == RequestStatus.success) {
          Toastification().show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text('Login successful'),
            description: Text("Welcome back to Zingo"),
            autoCloseDuration: const Duration(seconds: 4),
          );
          context.go('/home');
        }
        if (state.requestStatus == RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text('Login failed'),
            description: Text(state.error ?? 'An error occurred'),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;
        return Scaffold(
          appBar: AppBar(backgroundColor: AppColors.background),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const SizedBox(height: 28),
                    const LogoInfo(),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter your email",
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Enter your password",
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _isShowPassword = !_isShowPassword;
                          }),
                          icon: Icon(
                            _isShowPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: !_isShowPassword,
                    ),
                    _buildLoginButton(isLoading, context),
                    const AuthDivider(),
                    const LoginWithGoogleButton(),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.pushReplacement("/register"),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Sign up",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(bool isLoading, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _login(context),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text("Login"),
      ),
    );
  }
}
