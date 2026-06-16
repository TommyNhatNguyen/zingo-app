import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/screens/users/widgets/logout_button.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: AppColors.divider)),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            // Account
            _buildSection(
              context,
              title: "Tài khoản",
              child: Column(
                children: [
                  _buildSectionItem(
                    context,
                    title: "Cài đặt thông báo",
                    onTap: () {
                      print("hello");
                    },
                  ),
                  _buildSectionItem(
                    context,
                    title: "Cài đặt quyền riêng tư",
                    onTap: () {
                      print("hello");
                    },
                  ),
                ],
              ),
            ),
            // Subscription
            Divider(),
            _buildSection(
              context,
              title: "Gói đăng ký",
              child: Column(
                children: [
                  _buildSectionItem(
                    context,
                    title: "Chọn gói đăng ký",
                    onTap: () {
                      print("hello");
                    },
                  ),
                ],
              ),
            ),
            // Support
            Divider(),
            _buildSection(
              context,
              title: "Hỗ trợ",
              child: Column(
                children: [
                  _buildSectionItem(
                    context,
                    title: "Trung tâm trợ giúp",
                    onTap: () {
                      print("hello");
                    },
                  ),
                  _buildSectionItem(
                    context,
                    title: "Phản hồi",
                    onTap: () {
                      print("hello");
                    },
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
                  title: "Điều khoản dịch vụ",
                  onTap: () {
                    print("hello");
                  },
                ),
                _buildSectionItem(
                  context,
                  title: "Chính sách bảo mật",
                  onTap: () {
                    print("hello");
                  },
                ),
                _buildSectionItem(
                  context,
                  title: "Lời cảm ơn",
                  onTap: () {
                    print("hello");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildSectionItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
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
        trailing: Icon(Icons.chevron_right_rounded),
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
