import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/user-setting/widgets/logout_button.dart';

class UserSettingScreen extends StatelessWidget {
  const UserSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final _allowNotifications = ValueNotifier(true);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: AppColors.divider)),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = context.read<AuthBloc>().state.data?.id;
          if (userId != null) {
            context.read<UserConfigurationGetBloc>().add(
              UserConfigurationGetFetched(userId: userId),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              // Account
              _buildSection(
                context,
                title: l10n.account,
                child: Column(
                  children: [
                    _buildSectionItem(
                      context,
                      title: l10n.navProfile,
                      onTap: () {},
                    ),
                    _buildSectionItem(
                      context,
                      title: l10n.notifications,
                      trailing: ListenableBuilder(
                        listenable: _allowNotifications,
                        builder: (context, child) => Switch(
                          value: _allowNotifications.value,
                          onChanged: (value) {
                            _allowNotifications.value = value;
                          },
                        ),
                      ),
                      onTap: () {
                        _allowNotifications.value = !_allowNotifications.value;
                      },
                    ),
                  ],
                ),
              ),
              // Subscription
              const Divider(),
              _buildSection(
                context,
                title: l10n.subscription,
                child: Column(
                  children: [
                    _buildSectionItem(
                      context,
                      title: l10n.choosePlan,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              // Support
              const Divider(),
              _buildSection(
                context,
                title: l10n.support,
                child: Column(
                  children: [
                    _buildSectionItem(
                      context,
                      title: l10n.helpCenter,
                      onTap: () {},
                    ),
                    _buildSectionItem(
                      context,
                      title: l10n.acknowledgements,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              // Logout
              const LogoutButton(),
              // Terms of service & Privacy policy
              Column(
                children: [
                  _buildSectionItem(
                    context,
                    title: l10n.termsOfService,
                    onTap: () {},
                  ),
                  _buildSectionItem(
                    context,
                    title: l10n.privacyPolicy,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildSectionItem(
    BuildContext context, {
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  Column _buildSection(
    BuildContext context, {
    required String title,
    Widget? child,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        child ?? const SizedBox.shrink(),
      ],
    );
  }
}
