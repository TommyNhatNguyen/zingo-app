import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/widgets/pill_badge.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSettingsBloc, UserSettingsState>(
      builder: (context, state) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.divider),
          ),
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(
                        state.user?.username.substring(0, 1).toUpperCase() ??
                            'N/A',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.user?.username ?? 'N/A',
                            style: Theme.of(context).textTheme.headlineMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.user?.email ?? 'N/A',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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
                      child: Text(state.profile?.cefr_level ?? 'A1'),
                    ),
                    PillBadge(
                      background: AppColors.highlightContainer,
                      foreground: AppColors.xp,
                      icon: Icons.star_rounded,
                      child: Text('${state.profile?.xp ?? 0} XP'),
                    ),
                    PillBadge(
                      background: AppColors.accentContainer,
                      foreground: AppColors.streak,
                      icon: Icons.local_fire_department_rounded,
                      child: Text('${state.profile?.streak ?? 0} day streak'),
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
