import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_event.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart' as app_enums;
import 'package:zingo/constants/languages.dart';
import 'package:zingo/constants/practice_goal.dart';
import 'package:zingo/constants/topics.dart';
import 'package:zingo/dtos/user-profile/user_profile_create_dto.dart';
import 'package:zingo/screens/onboarding/widgets/daily_goal_page.dart';
import 'package:zingo/screens/onboarding/widgets/display_name_page.dart';
import 'package:zingo/screens/onboarding/widgets/english_level_page.dart';
import 'package:zingo/screens/onboarding/widgets/interest_topics_page.dart';
import 'package:zingo/screens/onboarding/widgets/native_language_page.dart';
import 'package:zingo/screens/onboarding/widgets/reminder_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  Language? _selectedLanguage;
  PracticeGoal? _selectedDailyGoal = PracticeGoal.all.first;
  app_enums.EnglishLevel? _selectedEnglishLevel;
  TimeOfDay? _selectedNotificationTime;
  final Set<String> _selectedTopicCodes = {};
  final PageController _pageViewController = PageController();
  bool _isDailyRemindersEnabled = true;

  int get _totalPages => _buildPages().length;

  List<Widget> _buildPages() {
    return [
      DisplayNamePage(nameController: _nameController),
      NativeLanguagePage(
        selectedLanguage: _selectedLanguage,
        onSelect: _selectLanguage,
      ),
      InterestTopicsPage(
        selectedTopics: _selectedTopicCodes,
        onSelect: _toggleTopic,
      ),
      DailyGoalPage(
        selectedGoal: _selectedDailyGoal,
        onSelect: _selectDailyGoal,
      ),
      ReminderPage(
        isDailyRemindersEnabled: _isDailyRemindersEnabled,
        selectedTime: _selectedNotificationTime,
        onToggleReminders: _toggleDailyReminders,
        onSelectTime: _selectNotificationTime,
      ),
      EnglishLevelPage(
        selectedLevel: _selectedEnglishLevel,
        onSelect: _selectEnglishLevel,
      ),
    ];
  }

  void _selectLanguage(Language language) {
    setState(() {
      _selectedLanguage = _selectedLanguage?.code == language.code
          ? null
          : language;
    });
  }

  void _selectDailyGoal(PracticeGoal value) {
    setState(() {
      _selectedDailyGoal = _selectedDailyGoal == value ? null : value;
    });
  }

  void _toggleDailyReminders() {
    setState(() {
      _isDailyRemindersEnabled = !_isDailyRemindersEnabled;
    });
  }

  void _selectEnglishLevel(app_enums.EnglishLevel level) {
    setState(() {
      _selectedEnglishLevel = _selectedEnglishLevel == level ? null : level;
    });
  }

  void _selectNotificationTime(TimeOfDay time) {
    setState(() {
      _selectedNotificationTime = _selectedNotificationTime == time
          ? null
          : time;
    });
  }

  void _toggleTopic(TopicCategory cat) {
    setState(() {
      if (_selectedTopicCodes.contains(cat.code)) {
        _selectedTopicCodes.remove(cat.code);
      } else {
        _selectedTopicCodes.add(cat.code);
      }
    });
  }

  void _navigateToPage(int index) {
    if (index < 0 || index >= _totalPages) return;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSubmit(BuildContext context) {
    final userId = context.read<AuthBloc>().state.data?.id;
    if (userId == null) return;

    final notificationTimeStr = _selectedNotificationTime != null
        ? '${_selectedNotificationTime!.hour.toString().padLeft(2, '0')}:${_selectedNotificationTime!.minute.toString().padLeft(2, '0')}'
        : null;

    context.read<UserProfileCreateBloc>().add(
      UserProfileCreateTrigger(
        payload: UserProfileCreateDto(
          user_id: userId,
          cefr_level: _selectedEnglishLevel ?? app_enums.EnglishLevel.A1,
          display_name: _nameController.text.trim().isEmpty
              ? 'User'
              : _nameController.text.trim(),
          mother_language: _selectedLanguage?.code ?? 'english',
          display_language: 'english',
          practice_goal_per_day: _selectedDailyGoal?.value,
          notification_time: notificationTimeStr,
          favorite_topics: _selectedTopicCodes.toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileCreateBloc, UserProfileCreateState>(
      listener: (context, state) {
        if (state.data != null &&
            state.requestStatus == app_enums.RequestStatus.success) {
          Toastification().show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text('Welcome to Zingo'),
            description: const Text(
              "Let's start using Zingo and boost your english skills with bite size dialogs",
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
          context.go('/home');
        } else if (state.requestStatus == app_enums.RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text('Something went wrong'),
            description: Text('Please try again'),
            autoCloseDuration: const Duration(seconds: 4),
          );
          _pageViewController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state.requestStatus == app_enums.RequestStatus.loading;
        final totalPages = _totalPages;
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                controller: _pageViewController,
                children: _buildPages(),
              ),
              Positioned.fill(
                child: ListenableBuilder(
                  listenable: _pageViewController,
                  builder: (context, _) {
                    final page = _pageViewController.hasClients
                        ? (_pageViewController.page ?? 0.0)
                        : 0.0;
                    return Stack(
                      children: [
                        _buildProgressBar(page, totalPages, context),
                        _buildActionButton(isLoading, page, totalPages),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(double page, int totalPages, BuildContext context) {
    final currentIndex = page.round();
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: currentIndex > 0
                        ? () => _navigateToPage(currentIndex - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    color: currentIndex > 0
                        ? AppColors.primary
                        : AppColors.textDisabled,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: LinearProgressIndicator(
                        value: (page + 1) / totalPages,
                        borderRadius: BorderRadius.circular(36),
                        backgroundColor: AppColors.divider,
                        color: AppColors.primary,
                        minHeight: 4,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${currentIndex + 1} of $totalPages',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(bool isLoading, double page, int totalPages) {
    final currentIndex = page.round();
    final isLastPage = currentIndex + 1 == totalPages;

    return Align(
      alignment: const Alignment(0, 0.9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 52,
        width: double.infinity,
        child: FilledButton(
          onPressed: isLoading
              ? null
              : () {
                  if (isLastPage) {
                    _onSubmit(context);
                  } else {
                    _navigateToPage(currentIndex + 1);
                  }
                },
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(isLastPage ? "Let's Go! 🚀" : 'Continue'),
        ),
      ),
    );
  }
}
