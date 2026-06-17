import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/user/get-profile/user_profile_get_bloc.dart';
import 'package:zingo/blocs/user/get-setting/user_settings_get_bloc.dart';
import 'package:zingo/constants/languages.dart';
import 'package:zingo/features/user/models/user_profile_screen_form_data.dart';
import 'package:zingo/features/user/widgets/user_profile_header.dart';
import 'package:zingo/widgets/pickers/languages_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final TextEditingController displayNameController;
  final UserProfileScreenFormData _form = UserProfileScreenFormData();

  UserProfileGetBloc get _userProfileGetBloc =>
      context.read<UserProfileGetBloc>();
  UserSettingsGetBloc get _userSettingsGetBloc =>
      context.read<UserSettingsGetBloc>();

  void _onSave(BuildContext context) {
    print(_form.displayName);
  }

  @override
  void initState() {
    super.initState();
    _form.initialize(
      displayName: _userProfileGetBloc.state.data?.display_name ?? "",
      motherLanguage: Language.fromId(
        _userProfileGetBloc.state.data?.mother_language ?? "",
      ),
    );
    displayNameController = TextEditingController(text: _form.displayName);
  }

  @override
  Widget build(BuildContext context) {
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
            enabled: false,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24,
                  children: [
                    const UserProfileHeader(),
                    _buildDisplayName(context),
                    _buildLanguageSection(context),
                    FilledButton(
                      onPressed: false ? null : () => _onSave(context),
                      child: false
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
          controller: displayNameController,
          onChanged: (name) => _form.update(displayName: name),
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Mother language',
          subtitle: 'The language you use to communicate with the app.',
        ),
        LanguagesPicker(
          value: _form.motherLanguage,
          onSelect: (language) => _form.update(motherLanguage: language),
          sheetTitle: 'Choose a language',
          sheetSubtitle: 'The language you use to communicate with the app.',
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
