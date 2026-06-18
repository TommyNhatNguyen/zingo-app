import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/config/app_text_styles.dart';
import 'package:zingo/l10n/l10n.dart';
import 'package:zingo/models/user_profile.dart';
import 'package:zingo/models/users.dart';

class HomeGreetingRow extends StatelessWidget {
  const HomeGreetingRow({super.key, required this.user, required this.profile});

  final Users? user;
  final UserProfile? profile;

  String _greeting(BuildContext context) {
    final l10n = context.l10n;
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting(context), style: AppTextStyles.bodySmall),
            Text(user?.username ?? '—', style: AppTextStyles.h2),
          ],
        ),
        const Spacer(),
        Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${profile?.xp ?? 0}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textOnAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.star_rounded,
                color: AppColors.textOnAccent,
                size: 16,
              ),
            ],
          ),
          backgroundColor: AppColors.xp,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
