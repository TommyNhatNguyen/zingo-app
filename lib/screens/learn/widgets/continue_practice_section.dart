import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_bloc.dart';
import 'package:zingo/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_event.dart';
import 'package:zingo/blocs/practice-sessions/list-active-dialogs/list_active_dialogs_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/practice-sessions/list_active_dialogs_payload.dart';
import 'package:zingo/screens/learn/widgets/empty_section.dart';
import 'package:zingo/screens/learn/widgets/topic_card.dart';

class ContinuePracticeSection extends StatefulWidget {
  const ContinuePracticeSection({super.key});

  @override
  State<ContinuePracticeSection> createState() =>
      _ContinuePracticeSectionState();
}

class _ContinuePracticeSectionState extends State<ContinuePracticeSection> {
  AuthBloc get authBloc => context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
    context.read<ListActiveDialogsBloc>().add(
      ListActiveDialogsFetch(
        payload: ListActiveDialogsPayload(userId: authBloc.state.data?.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListActiveDialogsBloc, ListActiveDialogsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.play_arrow, color: AppColors.accent),
                  Text(
                    "Continue practicing",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if ((state.data == null || state.data?.isEmpty == true) &&
                state.requestStatus != RequestStatus.loading)
              EmptySection(
                icon: Icon(Icons.coffee),
                title: Text(
                  "No sessions in progress",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Start a new session to continue practicing"),
                backgroundColor: AppColors.white,
                borderColor: AppColors.border,
                iconColor: AppColors.primaryContainer,
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Skeletonizer(
                  enabled: state.requestStatus == RequestStatus.loading,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 12,
                      children: (state.data ?? [])
                          .map((d) => TopicCard(dialog: d))
                          .toList(),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
