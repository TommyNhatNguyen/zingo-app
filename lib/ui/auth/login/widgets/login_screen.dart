import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_event.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/dtos/auth/login_dto.dart';
import 'package:zingo/ui/auth/widgets/auth_divider.dart';
import 'package:zingo/ui/auth/widgets/login_with_google_button.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/logo_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isShowPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
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
    final l10n = context.l10n;
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
            title: Text(l10n.signIn),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        if (state.requestStatus == RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: Text(state.error ?? l10n.errorGeneric),
            description: Text(state.error ?? l10n.errorGeneric),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state.requestStatus == RequestStatus.loading ||
            (state.requestStatus == RequestStatus.success &&
                state.data != null);
        return Scaffold(
          appBar: AppBar(backgroundColor: AppColors.background),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      const SizedBox(height: 28),
                      const LogoInfo(),
                      const SizedBox(height: 28),
                      TextFormField(
                        autofocus: true,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocusNode,
                        onFieldSubmitted: (value) =>
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
                        textInputAction: TextInputAction.done,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          labelText: l10n.passwordLabel,
                          prefixIcon: const Icon(Icons.lock),
                          hintText: l10n.passwordHint,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.passwordRequired;
                          }
                          return null;
                        },
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
                              TextSpan(text: "${l10n.signUp}? "),
                              TextSpan(
                                text: l10n.signUp,
                                style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }

  Widget _buildLoginButton(bool isLoading, BuildContext context) {
    final l10n = context.l10n;
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
            : Text(l10n.signIn),
      ),
    );
  }
}
