import 'package:flutter/material.dart';
import 'package:zingo/ver_2/ui/onboarding/widgets/profile_page.dart';
import 'package:zingo/l10n/l10n.dart';

class DisplayNamePage extends StatelessWidget {
  const DisplayNamePage({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ProfilePage(
      emoji: "👋",
      title: l10n.whatShouldWeCallYou,
      description: l10n.pickDisplayNameDesc,
      child: TextField(
        autofocus: true,
        controller: _nameController,
        decoration: InputDecoration(hintText: l10n.enterNameHint),
      ),
    );
  }
}
