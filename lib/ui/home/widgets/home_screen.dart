import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_bloc.dart';
import 'package:zingo/core/blocs/recommendations/journey/journey_event.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_event.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_event.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/dtos/journey/journey_payload.dart';
import 'package:zingo/domain/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/themes/app_text_styles.dart';
import 'package:zingo/ui/home/widgets/home_greeting_row.dart';
import 'package:zingo/ui/home/widgets/home_lesson_path.dart';
import 'package:zingo/ui/home/widgets/home_streak_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _expandedHeaderHeight = 280.0;
  late final SpeechToTextBloc _speechToTextBloc;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _headerCollapsed = false;

  @override
  void initState() {
    super.initState();
    _speechToTextBloc = SpeechToTextBloc();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speechToTextBloc.add(const SpeechToTextInitializeEvent());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _speechToTextBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final userId = context.read<AuthBloc>().state.data?.id ?? '';
    context.read<JourneyBloc>().add(
      JourneyFetchEvent(payload: JourneyPayload(user_id: userId)),
    );
    context.read<UserStreakGetBloc>().add(
      UserStreakGetFetched(
        payload: GetUserStreakPayload(
          user_id: userId,
          year: DateTime.now().year,
        ),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final media = MediaQuery.of(context);
    final collapseScrollOffset = _expandedHeaderHeight - kToolbarHeight;

    final showScrollToTop = pos.pixels > media.size.height / 2;
    final headerCollapsed = pos.pixels >= collapseScrollOffset - 8;
    if (showScrollToTop != _showScrollToTop ||
        headerCollapsed != _headerCollapsed) {
      setState(() {
        _showScrollToTop = showScrollToTop;
        _headerCollapsed = headerCollapsed;
      });
    }

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
        payload: JourneyPayload(
          page: (state.meta?.page ?? 1) + 1,
          user_id: context.read<AuthBloc>().state.data?.id ?? '',
        ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final authUser = authState.user;
        final user = authState.data;
        final profile = context
            .read<UserConfigurationGetBloc>()
            .state
            .data
            ?.profile;
        final topPadding = MediaQuery.of(context).padding.top;

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverSafeArea(
                  sliver: SliverAppBar(
                    pinned: true,
                    floating: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.background,
                    surfaceTintColor: AppColors.white,
                    scrolledUnderElevation: 4,
                    elevation: 4,
                    toolbarHeight: topPadding + kToolbarHeight,
                    shadowColor: AppColors.shadow,
                    expandedHeight: _expandedHeaderHeight,
                    actionsPadding: EdgeInsets.only(top: topPadding),
                    actions: _headerCollapsed
                        ? [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _HomeAppBarStatChip(
                                  icon: Icons.local_fire_department_rounded,
                                  value: '${profile?.streak ?? 0}',
                                  iconColor: AppColors.streak,
                                  backgroundColor: AppColors.accentContainer,
                                ),
                                const SizedBox(width: 8),
                                _HomeAppBarStatChip(
                                  icon: Icons.star_rounded,
                                  value: '${profile?.xp ?? 0}',
                                  iconColor: AppColors.textOnAccent,
                                  backgroundColor: AppColors.xp,
                                  labelColor: AppColors.textOnAccent,
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ]
                        : null,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: const EdgeInsetsDirectional.only(
                        start: 16,
                        bottom: 14,
                      ),
                      title: _headerCollapsed
                          ? Text(
                              (authUser?.isAnonymous == true ||
                                      authUser?.isAnonymous == null)
                                  ? "Guest User"
                                  : user?.username ?? '—',
                              style: AppTextStyles.h3,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : null,
                      background: ColoredBox(
                        color: AppColors.background,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              HomeGreetingRow(user: user, profile: profile),
                              const SizedBox(height: 14),
                              HomeStreakCard(profile: profile),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
                  sliver: const SliverToBoxAdapter(child: HomeLessonPath()),
                ),
              ],
            ),
            floatingActionButton: _showScrollToTop
                ? FloatingActionButton(
                    onPressed: _scrollToTop,
                    child: const Icon(Icons.arrow_upward),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _HomeAppBarStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color iconColor;
  final Color backgroundColor;
  final Color? labelColor;

  const _HomeAppBarStatChip({
    required this.icon,
    required this.value,
    required this.iconColor,
    required this.backgroundColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: labelColor ?? iconColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, color: iconColor, size: 16),
        ],
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
