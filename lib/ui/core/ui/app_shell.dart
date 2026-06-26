import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/core/blocs/connectivity/connectivity_bloc.dart';
import 'package:zingo/core/blocs/connectivity/connectivity_state.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/error/widgets/no_connection_screen.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      buildWhen: (prev, curr) => prev.isConnected != curr.isConnected,
      builder: (context, state) {
        return Scaffold(
          body: state.isConnected
              ? navigationShell
              : const NoConnectionScreen(),
          bottomNavigationBar: NavigationBar(
            indicatorColor: AppColors.primaryContainer,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: l10n.navHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore_rounded),
                label: l10n.navExplore,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings_rounded),
                label: l10n.navProfile,
              ),
            ],
          ),
        );
      },
    );
  }
}
