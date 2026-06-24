import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/dialog/recent/recent_dialogs_bloc.dart';
import 'package:zingo/blocs/dialog/recent/recent_dialogs_event.dart';
import 'package:zingo/blocs/dialog/recent/recent_dialogs_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog/recent_dialogs_payload.dart';
import 'package:zingo/ver_2/ui/explore/widgets/empty_section.dart';
import 'package:zingo/ver_2/ui/explore/widgets/topic_card.dart';
import 'package:zingo/l10n/l10n.dart';

class ContinuePracticeSection extends StatefulWidget {
  const ContinuePracticeSection({super.key});

  @override
  State<ContinuePracticeSection> createState() =>
      _ContinuePracticeSectionState();
}

class _ContinuePracticeSectionState extends State<ContinuePracticeSection> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthBloc>().state.data?.id ?? '';
    context.read<RecentDialogsBloc>().add(
      RecentDialogsFetchEvent(
        userId: userId,
        payload: const RecentDialogsPayload(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentDialogsBloc, RecentDialogsState>(
      builder: (context, state) {
        final isLoading =
            state.requestStatus == RequestStatus.loading ||
            state.requestStatus == RequestStatus.initial;
        final isEmpty =
            (state.data == null || state.data!.isEmpty) && !isLoading;
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: Column(
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
                      context.l10n.continuePracticing,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (isEmpty && state.requestStatus == RequestStatus.success)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EmptySection(
                    icon: Icon(Icons.coffee),
                    title: Text(
                      context.l10n.noSessionsInProgress,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(context.l10n.startNewSession),
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.border,
                    iconColor: AppColors.primaryContainer,
                  ),
                )
              else
                Skeletonizer(
                  enabled: isLoading,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 12,
                      children:
                          (isLoading
                                  ? List.generate(3, (_) => null)
                                  : state.data ?? [])
                              .map((d) => TopicCard(dialog: d))
                              .toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
