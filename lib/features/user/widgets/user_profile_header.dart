import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/user/get-profile/user_profile_get_bloc.dart';
import 'package:zingo/blocs/user/get-profile/user_profile_get_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/l10n/l10n.dart';
import 'package:zingo/widgets/pill_badge.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileGetBloc, UserProfileGetState>(
      builder: (context, state) {
        final l10n = context.l10n;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.divider),
          ),
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(
                        state.data?.display_name
                                ?.substring(0, 1)
                                .toUpperCase() ??
                            'N/A',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      state.data?.display_name ?? 'N/A',
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PillBadge(
                      background: AppColors.primaryContainer,
                      foreground: AppColors.primaryDark,
                      child: Text(state.data?.cefr_level.value ?? ''),
                    ),
                    PillBadge(
                      background: AppColors.highlightContainer,
                      foreground: AppColors.xp,
                      icon: Icons.star_rounded,
                      child: Text(l10n.xpPoints(state.data?.xp ?? 0)),
                    ),
                    PillBadge(
                      background: AppColors.accentContainer,
                      foreground: AppColors.streak,
                      icon: Icons.local_fire_department_rounded,
                      child: Text(l10n.streakDays(state.data?.streak ?? 0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
