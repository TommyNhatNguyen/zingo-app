import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/screens/learn/widgets/dialog_list.dart';
import 'package:zingo/screens/learn/widgets/streak_card.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
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
            title: Text("Pick a dialog"),
            centerTitle: false,
            actions: [
              Chip(
                avatar: Icon(Icons.star_border, color: AppColors.xp),
                label: Text('$total', style: TextStyle(color: AppColors.xp)),
                backgroundColor: AppColors.highlightContainer,
              ),
            ],
          ),
          body: SafeArea( 
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: const StreakCard(),
                  ),
                  const DialogList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
