import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_event.dart';
import 'package:zingo/core/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/models/dialog.dart' as dialog_model;
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/explore/widgets/recommendation_card.dart';
import 'package:zingo/ui/explore/widgets/recommendation_filter.dart';

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  bool _hasMore(DialogListState state) {
    final meta = state.meta;
    if (meta == null) return false;
    return meta.page * meta.limit < meta.total;
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          children: [
            Icon(Icons.auto_awesome, size: 18, color: AppColors.highlight),
            Text(
              context.l10n.recommendedForYou,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          context.l10n.recommendedSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  List<Widget> _buildSkeletonList() {
    return List.generate(3, (_) => const RecommendationCard(dialog: null));
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          context.l10n.noSessionsInProgress,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildDialogList(
    BuildContext context, {
    required bool isLoading,
    required List<dialog_model.Dialog> items,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: isLoading
            ? _buildSkeletonList()
            : items.isEmpty
            ? [_buildEmptyState(context)]
            : items
                  .map(
                    (d) => RecommendationCard(key: ValueKey(d.id), dialog: d),
                  )
                  .toList(),
      ),
    );
  }

  Widget _buildLoadMoreButton(
    BuildContext context,
    DialogListBloc bloc, {
    required bool isLoadingMore,
  }) {
    return Center(
      child: TextButton.icon(
        onPressed: isLoadingMore
            ? null
            : () => bloc.add(const DialogListFetchMoreEvent()),
        iconAlignment: IconAlignment.end,
        icon: isLoadingMore
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.expand_more),
        label: Text(context.l10n.loadMore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogListBloc, DialogListState>(
      builder: (context, state) {
        final bloc = context.read<DialogListBloc>();
        final isLoading = state.requestStatus == RequestStatus.loading;
        final isLoadingMore = state.requestStatus == RequestStatus.loadingMore;
        final items = state.data ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                _buildHeader(context),
                const RecommendationFilter(),
                _buildDialogList(context, isLoading: isLoading, items: items),
                if (!isLoading && _hasMore(state))
                  _buildLoadMoreButton(
                    context,
                    bloc,
                    isLoadingMore: isLoadingMore,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
