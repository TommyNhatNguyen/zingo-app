import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/recommendations/list/recommendations_list_bloc.dart';
import 'package:zingo/blocs/recommendations/list/recommendations_list_event.dart';
import 'package:zingo/blocs/recommendations/list/recommendations_list_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/recommendations/recommendations_payload.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;
import 'package:zingo/models/journey.dart';
import 'package:zingo/l10n/l10n.dart';
import 'package:zingo/ver_2/utils/capitalize_util.dart';

class RecommendationSection extends StatefulWidget {
  const RecommendationSection({super.key});

  @override
  State<RecommendationSection> createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  AuthBloc get authBloc => context.read<AuthBloc>();

  RecommendationsPayload get _basePayload =>
      RecommendationsPayload(user_id: authBloc.state.data?.id ?? '');

  @override
  void initState() {
    super.initState();
    context.read<RecommendationsListBloc>().add(
      RecommendationsListFetch(payload: _basePayload),
    );
  }

  List<dialog_model.Dialog> _flattenDialogs(JourneyResponse? response) {
    if (response == null) return [];
    return response.chapters
        .expand((c) => c.dialogs.map((s) => s.dialog))
        .toList();
  }

  void _loadMore(RecommendationsListState state) {
    final nextPage = (state.data?.meta.page ?? 1) + 1;
    context.read<RecommendationsListBloc>().add(
      RecommendationsListFetchMore(
        payload: _basePayload.copyWith(page: nextPage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsListBloc, RecommendationsListState>(
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;
        final isLoadingMore = state.requestStatus == RequestStatus.loadingMore;
        final items = _flattenDialogs(state.data);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 18,
                          color: AppColors.highlight,
                        ),
                        Text(
                          context.l10n.recommendedForYou,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      context.l10n.recommendedSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: isLoading
                        ? List.generate(
                            3,
                            (_) => const _RecommendationCard(dialog: null),
                          )
                        : items
                              .map((d) => _RecommendationCard(dialog: d))
                              .toList(),
                  ),
                ),
                if (!isLoading && state.hasMore)
                  Center(
                    child: TextButton.icon(
                      onPressed: isLoadingMore ? null : () => _loadMore(state),
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
                  ),
              ],
            ),
          ),
        ));
      },
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final dialog_model.Dialog? dialog;

  const _RecommendationCard({required this.dialog});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: InkWell(
        onTap: dialog == null
            ? null
            : () => context.push('/learn/${dialog!.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: AppColors.primaryContainer,
                        child:
                            dialog?.thumbnail_url != null &&
                                dialog!.thumbnail_url!.isNotEmpty
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: dialog!.thumbnail_url!,
                              )
                            : Image.asset(
                                'assets/default-fallback-image.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (dialog?.cefr_level != null)
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            dialog?.cefr_level ?? '',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    if (dialog?.topics?.name != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4,
                        children: [
                          const Icon(
                            Icons.folder_open_rounded,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          Expanded(
                            child: Text(
                              CapitalizeUtil.capitalize(
                                text: dialog!.topics!.name,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    Text(
                      CapitalizeUtil.capitalize(text: dialog?.title ?? ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (dialog?.description != null)
                      Text(
                        dialog!.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    Row(
                      spacing: 6,
                      children: [
                        if (dialog?.duration != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              CapitalizeUtil.capitalize(text: dialog!.duration),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        Text(
                          "${dialog?.conversation_length ?? 0} turns",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
