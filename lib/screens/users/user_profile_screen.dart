import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/user-profile/get/user_profile_get_bloc.dart';
import 'package:zingo/blocs/user-profile/get/user_profile_get_state.dart';
import 'package:zingo/blocs/user-settings/user_settings_bloc.dart';
import 'package:zingo/constants/enums.dart' as app_enums;
import 'package:zingo/constants/practice_goal.dart';
import 'package:zingo/dtos/user-profile/user_profile_update_dto.dart';
import 'package:zingo/screens/users/model/user_profile_form_data.dart';
import 'package:zingo/screens/users/widgets/daily_goal.dart';
import 'package:zingo/screens/users/widgets/reminder_time.dart';
import 'package:zingo/screens/users/widgets/user_profile_header.dart';
import 'package:zingo/widgets/pickers/english_level_picker.dart';
import 'package:zingo/widgets/pickers/languages_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileFormData _form = UserProfileFormData(
    payload: UserProfileUpdateDto(),
  );

  @override
  void dispose() {
    super.dispose();
  }

  void _onSave(BuildContext context) {
    final userId = context.read<UserSettingsBloc>().state.user?.id;
    if (userId == null) return;
    print(_form.payload.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileGetBloc, UserProfileGetState>(
      listener: (context, state) {
        if (state.requestStatus == app_enums.RequestStatus.success &&
            state.data != null) {
          _form.update(
            UserProfileUpdateDto.fromJson(state.data?.toJson() ?? {}),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state.requestStatus == app_enums.RequestStatus.loading;
        final isSaving = state.requestStatus == app_enums.RequestStatus.loading;
        return ListenableBuilder(
          listenable: _form,
          builder: (context, _) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Profile settings'),
                actions: [
                  IconButton(
                    onPressed: () => context.push('/setting'),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
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
                        selected: _form.payload.mother_language,
                        onChanged: (code) {
                          _form.update(
                            _form.payload.copyWith(mother_language: code),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildLanguageSection(
                        context: context,
                        title: 'Display language',
                        subtitle: 'Language used across the app.',
                        selected: _form.payload.display_language,
                        onChanged: (code) {
                          _form.update(
                            _form.payload.copyWith(display_language: code),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      DailyGoal(
                        dailyGoal: PracticeGoal.all.firstWhere(
                          (goal) =>
                              goal.value == _form.payload.practice_goal_per_day,
                          orElse: () => PracticeGoal.all.first,
                        ),
                        onChange: (goal) {
                          _form.update(
                            _form.payload.copyWith(
                              practice_goal_per_day: goal.value,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ReminderTime(
                        notificationTime:
                            _form.parseTime(_form.payload.notification_time) ??
                            TimeOfDay.now(),
                        onChange: (time) {
                          _form.update(
                            _form.payload.copyWith(
                              notification_time: time.toString(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // _buildTopics(context),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: _buildSaveButton(
                isSaving: isSaving,
                isLoading: isLoading,
                context: context,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSaveButton({
    required bool isSaving,
    required bool isLoading,
    required BuildContext context,
  }) {
    return SafeArea(
      top: false,
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
          controller: TextEditingController(text: _form.payload.display_name),
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
          value: app_enums.EnglishLevel.fromValue(
            app_enums.EnglishLevel.A1.value,
          ),
          onChanged: (lvl) => {},
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
        // FavoriteTopicsPicker(
        //   value: Set<String>.from(_form.payload.favorite_topics ?? []),
        //   onChanged: (next) {
        //     _form.update(
        //       _form.payload.copyWith(favorite_topics: next.toList()),
        //     );
        //   },
        // ),
      ],
    );
  }
}
