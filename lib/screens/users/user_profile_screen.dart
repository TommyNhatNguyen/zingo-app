import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/user-settings/user_settings_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_event.dart';
import 'package:zingo/blocs/user-settings/user_settings_state.dart';
import 'package:zingo/constants/enums.dart' as app_enums;
import 'package:zingo/constants/practice_goal.dart';
import 'package:zingo/dtos/user-profile/user_profile_update_dto.dart';
import 'package:zingo/screens/users/widgets/daily_goal.dart';
import 'package:zingo/screens/users/widgets/logout_button.dart';
import 'package:zingo/screens/users/widgets/reminder_time.dart';
import 'package:zingo/screens/users/widgets/user_profile_header.dart';
import 'package:zingo/widgets/pickers/english_level_picker.dart';
import 'package:zingo/widgets/pickers/favorite_topics_picker.dart';
import 'package:zingo/widgets/pickers/languages_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  app_enums.EnglishLevel? _cefr;
  String? _motherLanguage;
  String? _displayLanguage;
  int _dailyGoal = 1;
  TimeOfDay? _notificationTime;
  Set<String> _topicCodes = <String>{};
  bool _hydrated = false;
  app_enums.EnglishLevel? _initialCefr;
  Set<String> _initialTopics = <String>{};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _hydrateFrom(UserSettingsState state) {
    if (_hydrated || state.loadStatus != app_enums.RequestStatus.success) {
      return;
    }
    final user = state.user;
    final profile = state.profile;
    _nameController.text = profile?.display_name ?? user?.username ?? '';
    _cefr = _cefrFromString(profile?.cefr_level);
    _motherLanguage = profile?.mother_language;
    _displayLanguage = profile?.display_language;
    _dailyGoal = profile?.practice_goal_per_day ?? 1;
    _notificationTime = _parseTime(profile?.notification_time);
    _topicCodes = state.topicCodes.toSet();
    _initialCefr = _cefr;
    _initialTopics = state.topicCodes.toSet();
    _hydrated = true;
  }

  app_enums.EnglishLevel? _cefrFromString(String? raw) {
    if (raw == null) return null;
    return app_enums.EnglishLevel.values.firstWhere(
      (e) => e.value == raw,
      orElse: () => app_enums.EnglishLevel.A1,
    );
  }

  TimeOfDay? _parseTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _onSave(BuildContext context) {
    final state = context.read<UserSettingsBloc>().state;
    final userId = state.user?.id;
    if (userId == null) return;

    final profileDto = UserProfileUpdateDto(
      display_name: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      mother_language: _motherLanguage,
      display_language: _displayLanguage,
      practice_goal_per_day: _dailyGoal,
      notification_time: _formatTime(_notificationTime),
    );

    final cefrChanged = _cefr != null && _cefr != _initialCefr;
    final topicsChanged = !_setEquals(_topicCodes, _initialTopics);

    context.read<UserSettingsBloc>().add(
      UserSettingsSaved(
        userId: userId,
        profile: profileDto,
        cefrLevel: cefrChanged ? _cefr : null,
        topicCodes: topicsChanged ? _topicCodes.toList() : null,
      ),
    );
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    for (final v in a) {
      if (!b.contains(v)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserSettingsBloc, UserSettingsState>(
      listener: (context, state) {
        _hydrateFrom(state);

        if (state.saveStatus == app_enums.RequestStatus.success) {
          _initialCefr = _cefr;
          _initialTopics = _topicCodes.toSet();
          Toastification().show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text('Saved'),
            description: const Text('Your settings have been updated.'),
            autoCloseDuration: const Duration(seconds: 3),
          );
        }

        if (state.saveStatus == app_enums.RequestStatus.error ||
            state.loadStatus == app_enums.RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text('Something went wrong'),
            description: Text(state.error ?? 'Please try again'),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.loadStatus == app_enums.RequestStatus.loading;
        final isSaving = state.saveStatus == app_enums.RequestStatus.loading;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile settings')),
          body: Skeletonizer(
            enabled: isLoading,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  const UserProfileHeader(),
                  const SizedBox(height: 24),
                  _buildDisplayName(context),
                  const SizedBox(height: 24),
                  _buildEnglishLevel(context),
                  const SizedBox(height: 24),
                  _buildLanguageSection(
                    context: context,
                    title: 'Native language',
                    subtitle: "We'll tailor tips and translations.",
                    selected: _motherLanguage,
                    onChanged: (code) => setState(() => _motherLanguage = code),
                  ),
                  const SizedBox(height: 24),
                  _buildLanguageSection(
                    context: context,
                    title: 'Display language',
                    subtitle: 'Language used across the app.',
                    selected: _displayLanguage,
                    onChanged: (code) =>
                        setState(() => _displayLanguage = code),
                  ),
                  const SizedBox(height: 24),
                  DailyGoal(
                    dailyGoal: PracticeGoal.all.firstWhere(
                      (goal) => goal.value == _dailyGoal,
                    ),
                    onChange: (goal) => setState(() => _dailyGoal = goal.value),
                  ),
                  const SizedBox(height: 24),
                  ReminderTime(
                    notificationTime: _notificationTime ?? TimeOfDay.now(),
                    onChange: (time) =>
                        setState(() => _notificationTime = time),
                  ),
                  const SizedBox(height: 24),
                  _buildTopics(context),
                  const SizedBox(height: 24),
                  LogoutButton(disabled: isSaving || isLoading),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildSaveChangesButton(
            isSaving,
            isLoading,
            context,
          ),
        );
      },
    );
  }

  SafeArea _buildSaveChangesButton(
    bool isSaving,
    bool isLoading,
    BuildContext context,
  ) {
    return SafeArea(
      top: false,
      bottom: true,
      minimum: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: isSaving || isLoading ? null : () => _onSave(context),
            child: isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save changes'),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: textTheme.bodySmall),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDisplayName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Display name',
          subtitle: 'How we greet you in the app.',
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
      ],
    );
  }

  Widget _buildEnglishLevel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Your English level',
          subtitle: "We'll match dialogs to your comfort zone.",
        ),
        EnglishLevelPicker(
          value: _cefr,
          onChanged: (lvl) => setState(() => _cefr = lvl),
        ),
      ],
    );
  }

  Widget _buildLanguageSection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String? selected,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title: title, subtitle: subtitle),
        LanguagesPicker(
          value: selected,
          onChanged: onChanged,
          sheetTitle: title,
          sheetSubtitle: subtitle,
        ),
      ],
    );
  }

  Widget _buildTopics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Favourite topics',
          subtitle: "Pick as many as you like; we'll personalise your dialogs.",
        ),
        FavoriteTopicsPicker(
          value: _topicCodes,
          onChanged: (next) => setState(() => _topicCodes = next),
        ),
      ],
    );
  }
}
