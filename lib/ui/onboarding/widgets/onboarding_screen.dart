import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_state.dart';
import 'package:zingo/ui/onboarding/widgets/display_language_page.dart';
import 'package:zingo/ui/onboarding/widgets/display_name_page.dart';

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
      // Toastification().show(
      //   context: context,
      //   type: ToastificationType.success,
      //   style: ToastificationStyle.flat,
      //   title: Text(context.l10n.welcomeLearnerTitle),
      //   description: Text(context.l10n.welcomeLearnerDesc),
      //   autoCloseDuration: const Duration(seconds: 5),
      // );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingViewBloc(),
      child: BlocBuilder<OnboardingViewBloc, OnboardingViewState>(
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
                        _buildPage(context: context, child: Text("data")),
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
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required OnboardingViewState state,
  }) {
    void onNextPage() {
      _pageController.animateToPage(
        state.page + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      FocusScope.of(context).unfocus();
      debugPrint('state.displayName: ${state.toString()}');
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
