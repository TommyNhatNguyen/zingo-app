import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/users/users_bloc.dart';
import 'package:zingo/blocs/users/users_event.dart';
import 'package:zingo/blocs/users/users_state.dart';
import 'package:zingo/constants/enums.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<UsersBloc>().add(
      UsersRegister(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.success) {
          Toastification().show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text('Welcome to Zingo'),
            description: Text(
              "Let's start using Zingo and boost your english skills with bite size dialogs",
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
          final user = state.data;
          if (user != null) {
            context.read<AuthBloc>().add(AuthApplyBackendUser(data: user));
          }
          context.go('/profile');
        }
        if (state.requestStatus == RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text('Registration failed'),
            description: Text(state.error ?? 'An error occurred'),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;
        return Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
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
                        "assets/logo_zingo.svg",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Create an account",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              "Let's start using Zingo and boost your english skills with bite size dialogs",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter your username",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter your email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Enter your password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value != _confirmPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Confirm your password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password is required';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _register(context),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Register"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.pushReplacement("/login"),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Sign in",
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
