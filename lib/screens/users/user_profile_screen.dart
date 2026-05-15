import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/user-settings/user_settings_bloc.dart';
import 'package:zingo/blocs/user-settings/user_settings_event.dart';
import 'package:zingo/blocs/user-settings/user_settings_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart' as app_enums;
import 'package:zingo/constants/notification_time.dart';
import 'package:zingo/constants/practice_goal.dart';
import 'package:zingo/dtos/user-profile/user_profile_update_dto.dart';
import 'package:zingo/widgets/card_select.dart';
import 'package:zingo/widgets/english_level_picker.dart';
import 'package:zingo/widgets/favorite_topics_picker.dart';
import 'package:zingo/widgets/languages_picker.dart';
import 'package:zingo/widgets/time_picker.dart';

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

  // Snapshot of loaded values used to compute diffs at save time.
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
    _cefr = _cefrFromString(user?.cefr_level);
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
          // Refresh diff snapshot so subsequent saves are minimal.
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
          appBar: AppBar(title: const Text('Settings')),
          body: isLoading && !_hydrated
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      _buildHeader(context, state),
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
                        onChanged: (code) =>
                            setState(() => _motherLanguage = code),
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
                      _buildDailyGoal(context),
                      const SizedBox(height: 24),
                      _buildReminderTime(context),
                      const SizedBox(height: 24),
                      _buildTopics(context),
                      const SizedBox(height: 24),
                      _buildLogoutButton(context, isSaving),
                    ],
                  ),
                ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: isSaving || isLoading
                      ? null
                      : () => _onSave(context),
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
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, UserSettingsState state) {
    final user = state.user;
    final username = user?.username ?? 'You';
    final email = user?.email ?? '';
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    final textTheme = Theme.of(context).textTheme;

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
                    initial,
                    style: textTheme.headlineMedium?.copyWith(
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
                        username,
                        style: textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: textTheme.bodySmall,
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
                _StatPill(
                  label: user?.cefr_level ?? 'A1',
                  background: AppColors.primaryContainer,
                  foreground: AppColors.primaryDark,
                ),
                _StatPill(
                  label: '${user?.xp ?? 0} XP',
                  background: AppColors.highlightContainer,
                  foreground: AppColors.xp,
                  icon: Icons.star_rounded,
                ),
                _StatPill(
                  label: '${user?.streak ?? 0} day streak',
                  background: AppColors.accentContainer,
                  foreground: AppColors.streak,
                  icon: Icons.local_fire_department_rounded,
                ),
              ],
            ),
          ],
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

  Widget _buildDailyGoal(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Daily goal',
          subtitle: 'How many dialogs do you want to practice each day?',
        ),
        RadioGroup<int>(
          groupValue: _dailyGoal,
          onChanged: (value) => setState(() => _dailyGoal = value ?? 1),
          child: Column(
            children: [
              for (final goal in PracticeGoal.all)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _dailyGoal = goal.value),
                    borderRadius: BorderRadius.circular(12),
                    child: Card.outlined(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.divider),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    goal.description,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Radio<int>(value: goal.value),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Reminder time',
          subtitle: "We'll nudge you so you never break your streak.",
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.4,
          crossAxisCount: 2,
          children: NotificationTime.all.map((nt) {
            return CardSelect(
              emoji: nt.emoji,
              label: nt.label,
              isSelected: _notificationTime == nt.value,
              onTap: () => setState(
                () => _notificationTime = _notificationTime == nt.value
                    ? null
                    : nt.value,
              ),
              labelStyle: Theme.of(context).textTheme.bodySmall,
              labelMaxLines: 2,
              checkIconSize: 16,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Text(
          'Or pick a custom time',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        TimePicker(
          value: _notificationTime,
          onConfirm: (time) =>
              setState(() => _notificationTime = time ?? _notificationTime),
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

  Widget _buildLogoutButton(BuildContext context, bool isSaving) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: isSaving
            ? null
            : () => context.read<AuthBloc>().add(const AuthLoggedOut()),
        icon: const Icon(Icons.logout, color: AppColors.scoreLow),
        label: Text(
          'Log out',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.scoreLow),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.scoreLow,
          side: const BorderSide(color: AppColors.divider),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  const _StatPill({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
