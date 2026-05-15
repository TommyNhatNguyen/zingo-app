import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_bloc.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_event.dart';
import 'package:zingo/blocs/user-profile/user_profile_create_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/english_level.dart';
import 'package:zingo/constants/enums.dart' as app_enums;
import 'package:zingo/constants/languages.dart';
import 'package:zingo/constants/notification_time.dart';
import 'package:zingo/constants/practice_goal.dart';
import 'package:zingo/constants/topics.dart';
import 'package:zingo/dtos/user-profile/user_profile_create_dto.dart';
import 'package:zingo/widgets/card_select.dart';
import 'package:zingo/widgets/pickers/time_picker.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Language? _selectedLanguage;
  app_enums.EnglishLevel? _selectedEnglishLevel;
  TimeOfDay? _selectedNotificationTime;
  final Set<String> _selectedTopicCodes = {};
  final PageController _pageViewController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _selectedDailyGoal = 1;
  int _currentPageIndex = 0;
  bool _isDailyRemindersEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  void _selectDailyGoal(int value) {
    setState(() {
      _selectedDailyGoal = value;
    });
  }

  void _toggleDailyReminders() {
    setState(() {
      _isDailyRemindersEnabled = !_isDailyRemindersEnabled;
    });
  }

  void _selectLanguage(Language language) {
    setState(() {
      _selectedLanguage = _selectedLanguage?.code == language.code
          ? null
          : language;
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

  Widget _buildNotificationTimeCard(NotificationTime time) {
    return CardSelect(
      emoji: time.emoji,
      label: time.label,
      isSelected: _selectedNotificationTime == time.value,
      onTap: () => _selectNotificationTime(time.value),
      labelStyle: Theme.of(context).textTheme.bodySmall,
      labelMaxLines: 2,
      checkIconSize: 16,
    );
  }

  Widget _buildTopicCard(TopicCategory cat) {
    return CardSelect(
      emoji: cat.emoji,
      label: cat.name,
      isSelected: _selectedTopicCodes.contains(cat.code),
      onTap: () => _toggleTopic(cat),
      labelStyle: Theme.of(context).textTheme.bodySmall,
      labelMaxLines: 2,
      checkIconSize: 16,
    );
  }

  Widget _buildLanguageCard(Language lang) {
    return CardSelect(
      emoji: lang.flag,
      label: lang.nativeName,
      isSelected: _selectedLanguage?.code == lang.code,
      onTap: () => _selectLanguage(lang),
      emojiStyle: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget _buildEnglishLevelCard(EnglishLevel level) {
    final isSelected = _selectedEnglishLevel == level.code;
    return InkWell(
      onTap: () => _selectEnglishLevel(level.code),
      child: Card.outlined(
        color: isSelected ? AppColors.primaryContainer : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${level.code.value.toUpperCase()} · ${level.name}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      level.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard(PracticeGoal goal) {
    return InkWell(
      onTap: () => _selectDailyGoal(goal.value),
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                goal.emoji,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goal.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Radio(value: goal.value),
            ],
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    if (index < 0 || index >= 6) return;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPageIndex = index;
    });
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
          practice_goal_per_day: _selectedDailyGoal,
          notification_time: notificationTimeStr,
          favorite_topics: _selectedTopicCodes.toList(),
        ),
      ),
    );
  }

  void _onContinue(BuildContext context) {
    if (_currentPageIndex == 5) {
      _onSubmit(context);
    } else {
      _onPageChanged(_currentPageIndex + 1);
    }
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileCreateBloc, UserProfileCreateState>(
      listener: (context, state) {
        if (state.data != null &&
            state.requestStatus == app_enums.RequestStatus.success) {
          Toastification().show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text('Welcome to Zingo'),
            description: Text(
              "Let's start using Zingo and boost your english skills with bite size dialogs",
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
          context.go('/home');
        } else if (state.requestStatus == app_enums.RequestStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Something went wrong')),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: _pageViewController,
              onPageChanged: _onPageChanged,
              children: [
                _buildProfilePage(
                  context: context,
                  emoji: "👋",
                  title: "What should we call you?",
                  description:
                      "Pick a name that will be used to identify you in the app.",
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                    ),
                  ),
                ),
                _buildProfilePage(
                  context: context,
                  emoji: "🌍",
                  title: "What's your native language?",
                  description: "We'll tailor tips and translations for you.",
                  child: Expanded(
                    child: GridView.count(
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 2,
                      crossAxisCount: 2,
                      children: Language.all.map(_buildLanguageCard).toList(),
                    ),
                  ),
                ),
                _buildProfilePage(
                  context: context,
                  emoji: "💬",
                  title: "What topics interest you?",
                  description:
                      "Pick as many as you like. We'll personalise your dialogs.",
                  child: Expanded(
                    child: GridView.count(
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2,
                      crossAxisCount: 2,
                      children: TopicCategory.all.map(_buildTopicCard).toList(),
                    ),
                  ),
                ),
                _buildProfilePage(
                  context: context,
                  emoji: "🎯",
                  title: "Set your daily goal",
                  description:
                      "How many dialogs do you want to practice each day?",
                  child: Expanded(
                    child: RadioGroup(
                      groupValue: _selectedDailyGoal,
                      onChanged: (value) => _selectDailyGoal(value ?? 1),
                      child: ListView.separated(
                        itemBuilder: (context, index) =>
                            _buildDailyGoalCard(PracticeGoal.all[index]),
                        itemCount: PracticeGoal.all.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                      ),
                    ),
                  ),
                ),
                _buildProfilePage(
                  context: context,
                  emoji: "🔔",
                  title: "Reminder time",
                  description: "We'll nudge you so you never break your streak",
                  child: Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: _toggleDailyReminders,
                          child: Card.outlined(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: AppColors.divider),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Daily reminders",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Switch(
                                    value: _isDailyRemindersEnabled,
                                    onChanged: (value) =>
                                        _toggleDailyReminders(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          flex: 2,
                          child: GridView.count(
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            childAspectRatio: 2,
                            crossAxisCount: 2,
                            children: NotificationTime.all
                                .map(_buildNotificationTimeCard)
                                .toList(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Or pick a custom time"),
                              const SizedBox(height: 8),
                              TimePicker(
                                value:
                                    _selectedNotificationTime ??
                                    TimeOfDay.now(),
                                onConfirm: (time) => _selectNotificationTime(
                                  time ?? TimeOfDay.now(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
                _buildProfilePage(
                  context: context,
                  emoji: "📊",
                  title: "What's your English level?",
                  description: "We'll match dialogs to your comfort zone.",
                  child: Expanded(
                    child: ListView.separated(
                      itemCount: EnglishLevel.all.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) =>
                          _buildEnglishLevelCard(EnglishLevel.all[index]),
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                _onPageChanged(_currentPageIndex - 1),
                            icon: const Icon(Icons.arrow_back),
                            color: _currentPageIndex > 0
                                ? AppColors.primary
                                : AppColors.textDisabled,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: LinearProgressIndicator(
                                value: (_currentPageIndex + 1) / 6,
                                borderRadius: BorderRadius.circular(36),
                                backgroundColor: AppColors.divider,
                                color: AppColors.primary,
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => _onContinue(context),
                            child: Text(
                              _currentPageIndex == 5 ? 'Let\'s Go! 🚀' : 'Skip',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${_currentPageIndex + 1} of 6',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.84),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: 52,
                width: double.infinity,
                child:
                    BlocBuilder<UserProfileCreateBloc, UserProfileCreateState>(
                      builder: (context, state) {
                        final isLoading =
                            state.requestStatus ==
                            app_enums.RequestStatus.loading;
                        return FilledButton(
                          onPressed: isLoading
                              ? null
                              : () => _onContinue(context),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _currentPageIndex == 5
                                      ? 'Let\'s Go! 🚀'
                                      : 'Continue',
                                ),
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildProfilePage({
  required BuildContext context,
  required String emoji,
  required String title,
  required String description,
  Widget? child,
}) {
  return SafeArea(
    child: Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 100),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: Theme.of(context).textTheme.displayLarge),
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
          Text(description),
          const SizedBox(height: 16),
          child ?? const SizedBox.shrink(),
        ],
      ),
    ),
  );
}
