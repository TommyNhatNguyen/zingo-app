import 'package:flutter/material.dart';
import 'package:zingo/features/onboarding/widgets/profile_page.dart';

class DisplayNamePage extends StatelessWidget {
  const DisplayNamePage({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      emoji: "👋",
      title: "What should we call you?",
      description: "Pick a name that will be used to identify you in the app.",
      child: TextField(
        autofocus: true,
        controller: _nameController,
        decoration: const InputDecoration(hintText: "Enter your name"),
      ),
    );
  }
}
