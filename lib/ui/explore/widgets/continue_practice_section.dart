import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/core/blocs/dialog/popular/popular_dialogs_bloc.dart';
import 'package:zingo/core/l10n/l10n.dart';
import 'package:zingo/domain/models/dialog.dart' as dialog_model;
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/explore/widgets/empty_section.dart';
import 'package:zingo/ui/explore/widgets/topic_card.dart';

class ContinuePracticeSection extends StatelessWidget {
  const ContinuePracticeSection({super.key});

  static const _listHeight = 158.0;

  Widget _buildSkeletonRow() {
    return Skeletonizer(
      enabled: true,
      child: Row(
        spacing: 12,
        children: List.generate(3, (_) => const TopicCard()),
      ),
    );
  }

  Widget _buildEmptySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: EmptySection(
        icon: Icon(Icons.coffee),
        title: Text(
          context.l10n.noSessionsInProgress,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(context.l10n.startNewSession),
        backgroundColor: AppColors.white,
        borderColor: AppColors.border,
        iconColor: AppColors.primaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      PopularDialogsBloc,
      PagingState<int, dialog_model.Dialog>
    >(
      builder: (context, state) {
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
              if (state.status == PagingStatus.noItemsFound)
                _buildEmptySection(context)
              else
                SizedBox(
                  height: _listHeight,
                  child: PagedListView<int, dialog_model.Dialog>.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    state: state,
                    fetchNextPage: context
                        .read<PopularDialogsBloc>()
                        .fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) =>
                          TopicCard(dialog: item),
                      firstPageProgressIndicatorBuilder: (_) =>
                          _buildSkeletonRow(),
                      newPageProgressIndicatorBuilder: (_) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      invisibleItemsThreshold: 2,
                    ),
                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
