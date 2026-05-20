import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/auth/login_dto.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isShowPassword = false;

  void _toggleShowPassword() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

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

  void _loginWithGoogle(BuildContext context) {
    context.read<AuthBloc>().add(AuthLoginWithGoogle());
  }

  void _register() {
    context.go("/register");
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
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),
                    Center(
                      child: SvgPicture.asset(
                        "assets/logo_icon.svg",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Zingo",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              "Boost your english skills with bite size dialogs",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter your email",
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Enter your password",
                        suffixIcon: IconButton(
                          onPressed: _toggleShowPassword,
                          icon: Icon(
                            _isShowPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: !_isShowPassword,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _login(context),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        const SizedBox(width: 8),
                        Text("Or sign in with"),
                        const SizedBox(width: 8),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _loginWithGoogle(context),
                        icon: SvgPicture.network(
                          "https://upload.wikimedia.org/wikipedia/commons/3/3c/Google_Favicon_2025.svg",
                          fit: BoxFit.contain,
                          width: 24,
                          height: 24,
                        ),
                        label: const Text("Sign in with Google"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: isLoading ? null : () => _register(),
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
}
