import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/blocs/journey/journey_bloc.dart';
import 'package:zingo/blocs/journey/journey_event.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/journey/journey_payload.dart';
import 'package:zingo/features/home/widgets/home_greeting_row.dart';
import 'package:zingo/features/home/widgets/home_lesson_path.dart';
import 'package:zingo/features/home/widgets/home_streak_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;

    // Layout-phase notifications always fire at pixels == 0.
    // Require actual downward scroll before evaluating.
    if (pos.maxScrollExtent <= 0) return;
    if (pos.pixels <= 0) return;
    if (pos.pixels < pos.maxScrollExtent - 300) return;

    final state = context.read<JourneyBloc>().state;
    if (!state.hasMore) return;
    if (state.requestStatus == RequestStatus.loading ||
        state.requestStatus == RequestStatus.loadingMore) {
      return;
    }

    context.read<JourneyBloc>().add(
      JourneyFetchMoreEvent(
        payload: JourneyPayload(page: (state.meta?.page ?? 1) + 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.data;
        final profile = context
            .read<UserConfigurationGetBloc>()
            .state
            .data
            ?.profile;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGreetingRow(user: user, profile: profile),
                  const SizedBox(height: 14),
                  HomeStreakCard(profile: profile),
                  const SizedBox(height: 28),
                  const HomeLessonPath(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
