import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/themes/app_text_styles.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.onRetry, this.message});

  final VoidCallback? onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                SvgPicture.asset('assets/error_illustration.svg', width: 180),
                Text(
                  'Something went wrong',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  message ??
                      "We couldn't load what you were looking for.\nCheck your connection and try again.",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
