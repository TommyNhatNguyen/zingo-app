import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog/dialog_list_payload.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;

Map<int, String> weekdays = {
  1: "M",
  2: "T",
  3: "W",
  4: "T",
  5: "F",
  6: "S",
  7: "S",
};

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late final ScrollController _scrollController;
  late final List<DateTime> days;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    days = List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DialogListBloc>().add(
        DialogListFetchEvent(payload: DialogListPayload(page: 1, limit: 10)),
      );
    });
  }

  void _onScroll() {
    final bloc = context.read<DialogListBloc>();
    final isAtBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent;
    final meta = bloc.state.meta;
    final hasMore =
        meta != null && meta.page < (meta.total / meta.limit).ceil();
    if (isAtBottom &&
        hasMore &&
        bloc.state.requestStatus != RequestStatus.loading &&
        bloc.state.requestStatus != RequestStatus.loadingMore) {
      bloc.add(
        DialogListFetchMoreEvent(
          payload: DialogListPayload(page: meta.page + 1, limit: meta.limit),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            title: Text(
              "Pick a dialog",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            actions: [
              Chip(
                avatar: Icon(Icons.star_border, color: AppColors.xp),
                label: Text(
                  '${total}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.xp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.highlightContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  StreakCard(days: days),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.play_arrow),
                              const SizedBox(width: 8),
                              Text("Continue practicing"),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text("$total in progress"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: Skeletonizer(
                          enabled: state.requestStatus == RequestStatus.loading,
                          child: ListView.separated(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                (state.data?.length ?? 0) +
                                (state.requestStatus ==
                                        RequestStatus.loadingMore
                                    ? 1
                                    : 0),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, index) {
                              if (index == state.data?.length) {
                                return const SizedBox(
                                  width: 60,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return TopicCard(dialog: state.data?[index]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TopicCard extends StatelessWidget {
  final dialog_model.Dialog? dialog;

  const TopicCard({super.key, this.dialog});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(" tapped");
      },
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.accentContainer,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.cast_for_education),
                    ),
                    Align(
                      alignment: Alignment(0.88, -0.84),
                      child: FittedBox(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.star_border,
                                color: AppColors.textOnHighlight,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dialog?.xp_points.toString() ?? "",
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.88, 0.84),
                      child: FittedBox(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "${dialog?.conversation_length} turns",
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    dialog?.title ?? "",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    dialog?.description ?? "",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.days});

  final List<DateTime> days;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Icon(Icons.fireplace),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Daily streak'), Text("7 Days")],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Text("Best"), Text("14 days")],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weekdays[day.weekday] ?? "",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.fire_extinguisher_outlined),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.ads_click_outlined, size: 18),
                  const SizedBox(width: 8),
                  const Text("Practice today - keep the fire alive!"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
