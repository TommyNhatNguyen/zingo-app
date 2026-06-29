import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/user/create-profile/user_profile_create_bloc.dart';
import 'package:zingo/core/blocs/user/create-profile/user_profile_create_event.dart';
import 'package:zingo/core/blocs/user/create-profile/user_profile_create_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/dtos/user-profile/user_profile_create_dto.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_state.dart';
import 'package:zingo/ui/onboarding/widgets/display_language_page.dart';
import 'package:zingo/ui/onboarding/widgets/display_name_page.dart';
import 'package:zingo/ui/onboarding/widgets/english_level_page.dart';
import 'package:zingo/ui/onboarding/widgets/interest_topics_page.dart';
import 'package:zingo/ui/onboarding/widgets/mother_language_page.dart';
import 'package:zingo/ui/onboarding/widgets/reminder_page.dart';
import 'package:zingo/utils/parser_util.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Toastification().show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: Text(context.l10n.welcomeLearnerTitle),
        description: Text(context.l10n.welcomeLearnerDesc),
        autoCloseDuration: const Duration(seconds: 5),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingViewBloc, OnboardingViewState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            left: false,
            right: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                _buildProgressBar(context: context, state: state),
                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      context.read<OnboardingViewBloc>().add(
                        OnboardingViewGoToPage(page: page),
                      );
                    },
                    children: [
                      _buildPage(context: context, child: DisplayNamePage()),
                      _buildPage(
                        context: context,
                        child: DisplayLanguagePage(),
                      ),
                      _buildPage(context: context, child: MotherLanguagePage()),
                      _buildPage(context: context, child: ReminderPage()),
                      _buildPage(context: context, child: InterestTopicsPage()),
                      _buildPage(context: context, child: EnglishLevelPage()),
                    ],
                  ),
                ),
                // Action button
                _buildActionButton(context: context, state: state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required OnboardingViewState state,
  }) {
    void onNextPage() {
      if (state.page == 4 &&
          (state.favoriteTopics?.isEmpty == true ||
              state.favoriteTopics == null ||
              state.favoriteTopics!.length < 3)) {
        Toastification().show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          title: Text("Please select at least 3 topics"),
          autoCloseDuration: const Duration(seconds: 5),
        );
        return;
      }

      _pageController.animateToPage(
        state.page + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      FocusScope.of(context).unfocus();
      debugPrint('state.displayName: ${state.toString()}');
    }

    void onSubmit() {
      final user = context.read<AuthBloc>().state.user;
      context.read<UserProfileCreateBloc>().add(
        UserProfileCreateTrigger(
          payload: UserProfileCreateDto(
            user_id: user?.uid ?? '',
            display_name: state.displayName ?? '',
            display_language: state.displayLanguage?.id ?? '',
            mother_language: state.motherLanguage?.id ?? '',
            cefr_level: state.englishLevel ?? EnglishLevel.A1,
            practice_goal_per_day: state.practiceGoalPerDay ?? 0,
            notification_time: ParserUtil.formatTimeOfDay(
              state.notificationTime,
            ),
            favorite_topics: state.favoriteTopics ?? [],
          ),
        ),
      );
    }

    if (state.page == state.totalPage - 1) {
      return BlocBuilder<UserProfileCreateBloc, UserProfileCreateState>(
        builder: (context, createState) {
          final isLoading = createState.requestStatus == RequestStatus.loading;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onSubmit,
              label: isLoading ? Text("Submitting...") : Text("Submit"),
              icon: isLoading ? CircularProgressIndicator() : Icon(Icons.check),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.scoreHigh,
                foregroundColor: AppColors.white,
              ),
            ),
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onNextPage,
        label: Text("Continue"),
        icon: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _buildPage({required BuildContext context, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
      child: child,
    );
  }

  Widget _buildProgressBar({
    required BuildContext context,
    required OnboardingViewState state,
  }) {
    void onPreviousPage() {
      debugPrint("state.page: ${state.page}");
      if (state.page == 0) {
        context.go("/welcome", extra: {"from": "onboarding"});
        return;
      }
      _pageController.animateToPage(
        state.page - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          IconButton(onPressed: onPreviousPage, icon: Icon(Icons.arrow_back)),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.97,
                    child: SizedBox(height: 10, width: double.infinity),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: (state.page + 1) / state.totalPage * 0.97,
                    child: SizedBox(height: 10, width: double.infinity),
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
              children: [
                TextSpan(text: (state.page + 1).toString()),
                TextSpan(text: "/"),
                TextSpan(text: state.totalPage.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
