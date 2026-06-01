import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/screens/learn/widgets/continue_practice_section.dart';
import 'package:zingo/screens/learn/widgets/favorite_section.dart';
import 'package:zingo/screens/learn/widgets/recommendation_section.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  AuthBloc get authBloc => context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogListBloc, DialogListState>(
      builder: (context, state) {
        final total = state.meta?.total ?? 0;
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
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
          ),
        );
      },
    );
  }
}
