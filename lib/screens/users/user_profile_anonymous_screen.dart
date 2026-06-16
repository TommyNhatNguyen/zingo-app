import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/config/app_colors.dart';

class UserProfileAnonymousScreen extends StatelessWidget {
  const UserProfileAnonymousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hồ sơ'),
        shape: const Border(bottom: BorderSide(color: AppColors.divider)),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/setting");
            },
            icon: Icon(Icons.settings_outlined),
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
              "Bạn cần có hồ sơ để kết nối với bạn bè",
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
                  child: Text("Tạo tài khoản"),
                ),
                OutlinedButton(
                  onPressed: () {
                    context.push("/login");
                  },
                  child: Text("Đăng nhập"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
