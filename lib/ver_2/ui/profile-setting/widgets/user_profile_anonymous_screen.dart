import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/l10n/l10n.dart';

class UserProfileAnonymousScreen extends StatelessWidget {
  const UserProfileAnonymousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n.navProfile),
        shape: const Border(bottom: BorderSide(color: AppColors.divider)),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/setting");
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.needProfileToConnect,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Column(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.push("/register");
                  },
                  child: Text(l10n.createAccount),
                ),
                OutlinedButton(
                  onPressed: () {
                    context.push("/login");
                  },
                  child: Text(l10n.signIn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
