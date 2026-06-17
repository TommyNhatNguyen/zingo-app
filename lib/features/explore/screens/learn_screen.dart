import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/features/explore/widgets/continue_practice_section.dart';
import 'package:zingo/features/explore/widgets/favorite_section.dart';
import 'package:zingo/features/explore/widgets/recommendation_section.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actionsPadding: const EdgeInsets.only(right: 16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Browse all dialogs"),
            Text(
              "Practice freely without any filters",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              // In-progress dialogs
              ContinuePracticeSection(),
              // Your Favorites
              FavoriteSection(),
              // Recommended for you
              RecommendationSection(),
            ],
          ),
        ),
      ),
    );
  }
}
