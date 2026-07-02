import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/models/user_profile.dart';
import 'package:zingo/domain/models/users.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/themes/app_text_styles.dart';

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
    final authUser = context.read<AuthBloc>().state.user;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting(context), style: AppTextStyles.bodySmall),
              Text(
                (authUser?.isAnonymous == true || authUser?.isAnonymous == null)
                    ? 'Guest User'
                    : user?.username ?? '—',
                style: AppTextStyles.h2,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
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
