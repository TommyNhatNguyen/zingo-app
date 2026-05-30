import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.child,
  });

  final String emoji;
  final String title;
  final String description;
  final Widget? child;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 100),
        color: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.emoji, style: Theme.of(context).textTheme.displayLarge),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(widget.description),
            const SizedBox(height: 16),
            widget.child ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
