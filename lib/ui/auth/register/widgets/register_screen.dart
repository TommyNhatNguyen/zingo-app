import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_event.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/blocs/user/get/users_bloc.dart';
import 'package:zingo/core/blocs/user/get/users_event.dart';
import 'package:zingo/core/blocs/user/get/users_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/dtos/auth/login_dto.dart';
import 'package:zingo/ui/auth/widgets/auth_divider.dart';
import 'package:zingo/ui/auth/widgets/login_with_google_button.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';

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
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isRegistering = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isRegistering = true);
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
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (!_isRegistering) return;
            if (state.user != null &&
                state.requestStatus == RequestStatus.success) {
              context.go('/onboarding');
            }
            if (state.requestStatus == RequestStatus.error) {
              setState(() => _isRegistering = false);
            }
          },
        ),
        BlocListener<UsersBloc, UsersState>(
          listener: (context, state) {
            if (state.requestStatus == RequestStatus.success) {
              context.read<AuthBloc>().add(
                AuthLoginWithEmailAndPassword(
                  payload: LoginDto(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                  ),
                ),
              );
            }
            if (state.requestStatus == RequestStatus.error) {
              setState(() => _isRegistering = false);
              Toastification().show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.flat,
                title: Text(l10n.registrationFailed),
                description: Text(state.error ?? l10n.errorGeneric),
                autoCloseDuration: const Duration(seconds: 4),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          final isLoading =
              state.requestStatus == RequestStatus.loading || _isRegistering;
          return Scaffold(
            appBar: AppBar(backgroundColor: AppColors.background),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: _formKey,
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                    l10n.createAccount,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      l10n.registerTagline,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          autofocus: true,
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              _emailFocusNode.requestFocus(),
                          decoration: InputDecoration(
                            labelText: l10n.usernameLabel,
                            prefixIcon: const Icon(Icons.person),
                            hintText: l10n.usernameHint,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.usernameRequired;
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              _passwordFocusNode.requestFocus(),
                          decoration: InputDecoration(
                            labelText: l10n.emailLabel,
                            prefixIcon: const Icon(Icons.email),
                            hintText: l10n.emailHint,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.emailRequired;
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              _confirmPasswordFocusNode.requestFocus(),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.passwordLabel,
                            prefixIcon: const Icon(Icons.lock),
                            hintText: l10n.passwordHint,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.passwordRequired;
                            }
                            if (value != _confirmPasswordController.text) {
                              return l10n.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _register(context),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.confirmPasswordLabel,
                            prefixIcon: const Icon(Icons.lock),
                            hintText: l10n.confirmPasswordHint,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.confirmPasswordRequired;
                            }
                            if (value != _passwordController.text) {
                              return l10n.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                        _buildRegisterButton(isLoading, context),
                        const AuthDivider(),
                        const LoginWithGoogleButton(),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => context.pushReplacement("/login"),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "${l10n.alreadyHaveAccount} "),
                                TextSpan(
                                  text: l10n.signIn,
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
            ),
          );
        },
      ),
    );
  }

  SizedBox _buildRegisterButton(bool isLoading, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _register(context),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(context.l10n.register),
      ),
    );
  }
}
