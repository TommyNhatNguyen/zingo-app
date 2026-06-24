import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/locale/locale_cubit.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/blocs/user/update-configuration/user_configuration_update_bloc.dart';
import 'package:zingo/blocs/user/update-configuration/user_configuration_update_event.dart';
import 'package:zingo/blocs/user/update-configuration/user_configuration_update_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/constants/languages.dart';
import 'package:zingo/constants/practice_goal.dart';
import 'package:zingo/dtos/user-configuration/user_configuration_update_dto.dart';
import 'package:zingo/l10n/l10n.dart';
import 'package:zingo/utils/parser_util.dart';
import 'package:zingo/ver_2/ui/core/ui/pickers/languages_picker.dart';
import 'package:zingo/ver_2/ui/core/ui/pickers/practice_goal_picker.dart';
import 'package:zingo/ver_2/ui/core/ui/pickers/time_picker.dart';
import 'package:zingo/ver_2/ui/profile-setting/blocs/user_profile_screen_form_data.dart';
import 'package:zingo/ver_2/ui/profile-setting/widgets/user_profile_header.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final TextEditingController displayNameController;
  final UserProfileScreenFormData _form = UserProfileScreenFormData();

  UserConfigurationGetBloc get _userConfigBloc =>
      context.read<UserConfigurationGetBloc>();
  LocaleCubit get _localeCubit => context.read<LocaleCubit>();

  Future<void> _onRefresh() async {
    final userId = context.read<AuthBloc>().state.data?.id;
    if (userId != null) {
      _userConfigBloc.add(UserConfigurationGetFetched(userId: userId));
    }
  }

  void _onSave(BuildContext context) {
    final userId = context.read<AuthBloc>().state.data?.id;
    if (userId == null) return;

    final name = _form.displayName?.trim();
    final notificationTimeStr = _form.notificationTime != null
        ? '${_form.notificationTime!.hour.toString().padLeft(2, '0')}:${_form.notificationTime!.minute.toString().padLeft(2, '0')}'
        : null;

    context.read<UserConfigurationUpdateBloc>().add(
      UserConfigurationUpdateTriggered(
        userId: userId,
        payload: UserConfigurationUpdateDto(
          profile: UserConfigurationProfileDto(
            display_name: name?.isEmpty == true ? null : name,
            mother_language: _form.motherLanguage?.id,
          ),
          settings: UserConfigurationSettingsDto(
            practice_goal_per_day: _form.practiceGoal?.value,
            notification_time: notificationTimeStr,
            display_language: _form.displayLanguage?.id,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final configState = _userConfigBloc.state;
    _form.initialize(
      displayName: configState.data?.profile?.display_name ?? '',
      motherLanguage: Language.fromId(
        configState.data?.profile?.mother_language ?? '',
      ),
      displayLanguage: Language.fromId(
        configState.data?.settings?.display_language ??
            _localeCubit.state.languageCode,
      ),
      practiceGoal: PracticeGoal.fromValue(
        configState.data?.settings?.practice_goal_per_day,
      ),
      notificationTime: ParserUtil.parseTime(
        configState.data?.settings?.notification_time,
      ),
    );
    displayNameController = TextEditingController(text: _form.displayName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<
      UserConfigurationUpdateBloc,
      UserConfigurationUpdateState
    >(
      listener: (context, updateState) {
        if (updateState.requestStatus == RequestStatus.success) {
          Toastification().show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: Text(l10n.saveChanges),
            autoCloseDuration: const Duration(seconds: 3),
          );
          final userId = context.read<AuthBloc>().state.data?.id;
          if (userId != null) {
            _userConfigBloc.add(UserConfigurationGetFetched(userId: userId));
          }
        } else if (updateState.requestStatus == RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: Text(l10n.errorGeneric),
            description: Text(updateState.error ?? ''),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, updateState) {
        final isLoading = updateState.requestStatus == RequestStatus.loading;
        return ListenableBuilder(
          listenable: _form,
          builder: (context, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(l10n.profileSettings),
                actions: [
                  IconButton(
                    onPressed: () => context.push('/setting'),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              body: Skeletonizer(
                enabled: false,
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 24,
                        children: [
                          const UserProfileHeader(),
                          _buildDisplayName(context),
                          _buildDisplayLanguageSection(context),
                          _buildLanguageSection(context),
                          _buildPracticeGoalSection(context),
                          _buildNotificationTimeSection(context),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _onSave(context),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(l10n.saveChanges),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDisplayName(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: l10n.displayName,
          subtitle: l10n.displayNameSubtitle,
        ),
        TextField(
          controller: displayNameController,
          onChanged: (name) => _form.update(displayName: name),
          decoration: InputDecoration(hintText: l10n.displayNameHint),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: l10n.motherLanguage,
          subtitle: l10n.motherLanguageSubtitle,
        ),
        LanguagesPicker(
          value: _form.motherLanguage,
          onSelect: (language) => _form.update(motherLanguage: language),
          sheetTitle: l10n.chooseLanguage,
          sheetSubtitle: l10n.motherLanguageSubtitle,
        ),
      ],
    );
  }

  Future<void> _onDisplayLanguageSelect(
    BuildContext context,
    Language? language,
  ) async {
    if (language == null || language == _form.displayLanguage) return;
    final l10n = context.l10n;
    final localeCubit = context.read<LocaleCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.displayLanguage),
        content: Text(
          '${language.flag}  ${language.nativeName}',
          style: Theme.of(ctx).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    _form.update(displayLanguage: language);
    localeCubit.setLocale(language.id);
  }

  Widget _buildDisplayLanguageSection(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: l10n.displayLanguage,
          subtitle: l10n.displayLanguageSubtitle,
        ),
        LanguagesPicker(
          value: _form.displayLanguage,
          onSelect: (language) => _onDisplayLanguageSelect(context, language),
          sheetTitle: l10n.chooseLanguage,
          sheetSubtitle: l10n.displayLanguageSubtitle,
        ),
      ],
    );
  }

  Widget _buildNotificationTimeSection(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: l10n.notificationTime,
          subtitle: l10n.notificationTimeSubtitle,
        ),
        TimePicker(
          value: _form.notificationTime,
          placeholder: l10n.pickATime,
          onConfirm: (time) => _form.update(notificationTime: time),
        ),
      ],
    );
  }

  Widget _buildPracticeGoalSection(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: l10n.practiceGoal,
          subtitle: l10n.practiceGoalSubtitle,
        ),
        PracticeGoalPicker(
          value: _form.practiceGoal,
          onSelect: (goal) => _form.update(practiceGoal: goal),
          emptyLabel: l10n.pickAGoal,
          sheetTitle: l10n.choosePracticeGoal,
          sheetSubtitle: l10n.practiceGoalSubtitle,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
