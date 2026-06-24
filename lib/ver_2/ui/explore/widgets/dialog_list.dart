import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog/dialog_list_payload.dart';
import 'package:zingo/ver_2/ui/explore/widgets/topic_card.dart';
import 'package:zingo/l10n/l10n.dart';

class DialogList extends StatefulWidget {
  const DialogList({super.key});

  @override
  State<DialogList> createState() => _DialogListState();
}

class _DialogListState extends State<DialogList> {
  late final ScrollController _scrollController;
  DialogListBloc get bloc => context.read<DialogListBloc>();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    bloc.add(
      DialogListFetchEvent(payload: DialogListPayload(page: 1, limit: 10)),
    );
  }

  void _onScroll() {
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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(context.l10n.continuePracticing),
                    ],
                  ),
                  Text(context.l10n.sessionsInProgress(total)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 180,
                child: Skeletonizer(
                  enabled: state.requestStatus == RequestStatus.loading,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                        (state.data?.length ?? 0) +
                        (state.requestStatus == RequestStatus.loadingMore
                            ? 1
                            : 0),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      if (index == state.data?.length) {
                        return const SizedBox(
                          width: 60,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return TopicCard(dialog: state.data?[index]);
                    },
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
