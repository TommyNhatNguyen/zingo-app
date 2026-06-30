import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/core/blocs/auth/auth_bloc.dart';
import 'package:zingo/core/blocs/locale/locale_cubit.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_state.dart';
import 'package:zingo/core/blocs/user/update-configuration/user_configuration_update_bloc.dart';
import 'package:zingo/core/blocs/user/update-configuration/user_configuration_update_event.dart';
import 'package:zingo/core/blocs/user/update-configuration/user_configuration_update_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/constants/languages.dart';
import 'package:zingo/core/constants/practice_goal.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/dtos/user-configuration/user_configuration_update_dto.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/pickers/favorite_topics_picker.dart';
import 'package:zingo/ui/core/ui/pickers/languages_picker.dart';
import 'package:zingo/ui/core/ui/pickers/practice_goal_picker.dart';
import 'package:zingo/ui/core/ui/pickers/time_picker.dart';
import 'package:zingo/ui/profile-setting/blocs/user_profile_view_bloc.dart';
import 'package:zingo/ui/profile-setting/blocs/user_profile_view_event.dart';
import 'package:zingo/ui/profile-setting/blocs/user_profile_view_state.dart';
import 'package:zingo/ui/profile-setting/widgets/user_profile_header.dart';
import 'package:zingo/utils/parser_util.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  bool isLoading = false;

  void _onDisplayNameChanged({
    required BuildContext context,
    required String value,
  }) {
    final viewBloc = context.read<UserProfileViewBloc>();
    viewBloc.add(UserProfileViewUpdateForm(displayName: value));
  }

  void _onDisplayLanguageChanged({
    required BuildContext context,
    required Language? value,
  }) {
    if (value == null) return;
    final l10n = context.l10n;
    final viewBloc = context.read<UserProfileViewBloc>();
    final localeCubit = context.read<LocaleCubit>();
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.displayLanguage),
        content: Text(
          "We'll change the language of the app to this language.",
          style: Theme.of(ctx).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              viewBloc.add(UserProfileViewUpdateForm(displayLanguage: value));
              localeCubit.setLocale(value.id);
              Navigator.of(ctx).pop(true);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _onMotherLanguageChanged({
    required BuildContext context,
    required Language? value,
  }) {
    if (value == null) return;
    final viewBloc = context.read<UserProfileViewBloc>();
    viewBloc.add(UserProfileViewUpdateForm(motherLanguage: value));
  }

  void _onPracticeGoalChanged({
    required BuildContext context,
    required PracticeGoal? value,
  }) {
    if (value == null) return;
    final viewBloc = context.read<UserProfileViewBloc>();
    viewBloc.add(UserProfileViewUpdateForm(practiceGoal: value));
  }

  void _onNotificationTimeChanged({
    required BuildContext context,
    required TimeOfDay? value,
  }) {
    if (value == null) return;
    final viewBloc = context.read<UserProfileViewBloc>();
    viewBloc.add(UserProfileViewUpdateForm(notificationTime: value));
  }

  void _onFavoriteTopicsChanged({
    required BuildContext context,
    required List<String> value,
  }) {
    if (value.isEmpty || value.length < 3) {
      Toastification().show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text("Please select at least 3 topics"),
        autoCloseDuration: const Duration(seconds: 5),
      );
      return;
    }
    final viewBloc = context.read<UserProfileViewBloc>();
    viewBloc.add(UserProfileViewUpdateForm(favoriteTopics: value));
  }

  Future<void> _onConfirm({required BuildContext context}) async {
    final viewBloc = context.read<UserProfileViewBloc>();
    final userConfigUpdateBloc = context.read<UserConfigurationUpdateBloc>();
    final userId = context.read<AuthBloc>().state.data?.id;
    if (userId == null) return;
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm"),
        content: Text("Are you sure you want to save your changes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Confirm"),
          ),
        ],
      ),
    );
    if (result == null || result == false) return;
    userConfigUpdateBloc.add(
      UserConfigurationUpdateTriggered(
        userId: userId,
        payload: UserConfigurationUpdateDto(
          profile: UserConfigurationProfileDto(
            display_name: viewBloc.state.displayName?.isEmpty == true
                ? null
                : viewBloc.state.displayName,
            mother_language: viewBloc.state.motherLanguage?.id,
          ),
          settings: UserConfigurationSettingsDto(
            practice_goal_per_day: viewBloc.state.practiceGoal?.value,
            notification_time: ParserUtil.formatTimeOfDay(
              viewBloc.state.notificationTime,
            ),
            display_language: viewBloc.state.displayLanguage?.id,
          ),
          favorite_topics: viewBloc.state.favoriteTopics,
        ),
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _initialize(BuildContext context) {
    final userConfigBloc = context.read<UserConfigurationGetBloc>();
    final viewBloc = context.read<UserProfileViewBloc>();

    final state = userConfigBloc.state;
    viewBloc.add(
      UserProfileViewUpdateForm(
        displayName: state.data?.profile?.display_name,
        displayLanguage: state.data?.settings?.display_language != null
            ? Language.fromId(state.data?.settings?.display_language)
            : null,
        motherLanguage: state.data?.profile?.mother_language != null
            ? Language.fromId(state.data?.profile?.mother_language)
            : null,
        englishLevel: state.data?.profile?.cefr_level,
        practiceGoal: state.data?.settings?.practice_goal_per_day != null
            ? PracticeGoal.fromValue(
                state.data?.settings?.practice_goal_per_day,
              )
            : null,
        notificationTime: state.data?.settings?.notification_time != null
            ? ParserUtil.parseTime(state.data?.settings?.notification_time)
            : null,
        favoriteTopics:
            state.data?.profile?.favorite_topics
                ?.map((topic) => topic.topic_normalize_name)
                .toList() ??
            [],
      ),
    );
    _displayNameController.text = state.data?.profile?.display_name ?? '';
  }

  Future<void> _onRefresh() async {
    final userConfigBloc = context.read<UserConfigurationGetBloc>();
    final userId = context.read<AuthBloc>().state.data?.id;
    if (userId == null) return;
    userConfigBloc.add(UserConfigurationGetFetched(userId: userId));
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<UserConfigurationUpdateBloc, UserConfigurationUpdateState>(
          listener: (context, state) {
            setState(() {
              isLoading = RequestStatus.loading == state.requestStatus;
            });
            if (state.requestStatus == RequestStatus.success) {
              final userId = context.read<AuthBloc>().state.data?.id;
              if (userId == null) return;
              Toastification().show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.flat,
                title: Text("Your changes have been saved"),
                autoCloseDuration: const Duration(seconds: 3),
              );
              context.read<UserConfigurationGetBloc>().add(
                UserConfigurationGetFetched(userId: userId),
              );
            }
          },
        ),
        BlocListener<UserConfigurationGetBloc, UserConfigurationGetState>(
          listener: (context, state) {
            setState(() {
              isLoading = RequestStatus.loading == state.requestStatus;
            });
            if (state.requestStatus == RequestStatus.success &&
                state.data != null) {
              _initialize(context);
            }
          },
        ),
      ],
      child: BlocBuilder<UserProfileViewBloc, UserProfileViewState>(
        builder: (context, state) {
          return Skeletonizer(
            enabled: isLoading,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.white,
                    title: Text("Cài đặt"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          context.push('/setting');
                        },
                        icon: Icon(Icons.settings_outlined),
                      ),
                    ],
                    stretch: false,
                    floating: true,
                    pinned: true,
                    snap: true,
                    elevation: 1,
                    shadowColor: AppColors.shadow,
                    shape: const Border(
                      bottom: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 18,
                    ),
                    sliver: SliverToBoxAdapter(child: UserProfileHeader()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          _buildTitle(
                            context: context,
                            title: l10n.displayName,
                            subtitle: l10n.displayNameSubtitle,
                          ),
                          TextField(
                            controller: _displayNameController,
                            decoration: InputDecoration(
                              hintText: l10n.displayNameHint,
                            ),
                            onChanged: (value) => _onDisplayNameChanged(
                              context: context,
                              value: value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          _buildTitle(
                            context: context,
                            title: l10n.displayLanguage,
                            subtitle: l10n.displayLanguageSubtitle,
                          ),
                          LanguagesPicker(
                            onSelect: (value) => _onDisplayLanguageChanged(
                              context: context,
                              value: value,
                            ),
                            value: state.displayLanguage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          _buildTitle(
                            context: context,
                            title: l10n.motherLanguage,
                            subtitle: l10n.motherLanguageSubtitle,
                          ),
                          LanguagesPicker(
                            onSelect: (value) => _onMotherLanguageChanged(
                              context: context,
                              value: value,
                            ),
                            value: state.motherLanguage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          _buildTitle(
                            context: context,
                            title: l10n.practiceGoal,
                            subtitle: l10n.practiceGoalSubtitle,
                          ),
                          PracticeGoalPicker(
                            onSelect: (value) => _onPracticeGoalChanged(
                              context: context,
                              value: value,
                            ),
                            value: state.practiceGoal,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          _buildTitle(
                            context: context,
                            title: l10n.notificationTime,
                            subtitle: l10n.notificationTimeSubtitle,
                          ),
                          TimePicker(
                            onConfirm: (value) => _onNotificationTimeChanged(
                              context: context,
                              value: value,
                            ),
                            value: state.notificationTime,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      state.favoriteTopics.isEmpty ? 18 : 0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _buildTitle(
                        context: context,
                        title: l10n.favouriteTopics,
                        subtitle: l10n.favouriteTopicsSubtitle,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                    sliver: SliverToBoxAdapter(
                      child: FavoriteTopicsPicker(
                        allowClear: false,
                        value: state.favoriteTopics,
                        onChanged: (value) => _onFavoriteTopicsChanged(
                          context: context,
                          value: value,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        child: FilledButton(
                          onPressed: isLoading
                              ? null
                              : () => _onConfirm(context: context),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text('Confirm'),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 18)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle({
    required BuildContext context,
    required String title,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (subtitle != null)
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
