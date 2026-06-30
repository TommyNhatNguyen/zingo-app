import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/domain/models/dialog.dart' as dialog_model;
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/utils/capitalize_util.dart';

class RecommendationCard extends StatelessWidget {
  final dialog_model.Dialog? dialog;

  const RecommendationCard({super.key, required this.dialog});

  Widget _buildCefrChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          const Icon(
            Icons.language_rounded,
            size: 13,
            color: AppColors.textSecondary,
          ),
          Text(
            dialog!.cefr_level!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          const Icon(
            Icons.timer_rounded,
            size: 13,
            color: AppColors.textSecondary,
          ),
          Text(
            CapitalizeUtil.capitalize(text: dialog!.duration),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpBadge(BuildContext context) {
    return Positioned(
      top: 6,
      right: 6,
      child: FittedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_border,
                color: AppColors.textOnHighlight,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                dialog?.xp_points.toString() ?? '',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTurnsBadge(BuildContext context) {
    return Positioned(
      right: 6,
      bottom: 6,
      child: FittedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${dialog?.conversation_length ?? 0} turns',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return SizedBox(
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
          if (dialog != null) _buildXpBadge(context),
          if (dialog != null) _buildTurnsBadge(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      CapitalizeUtil.capitalize(text: dialog?.title ?? ''),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTopicRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            CapitalizeUtil.capitalize(text: dialog!.topics!.name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    final hasCefr = dialog?.cefr_level != null;
    final hasDuration = dialog?.duration != null;
    if (!hasCefr && !hasDuration) return const SizedBox.shrink();

    return Row(
      spacing: 6,
      children: [
        if (hasCefr) _buildCefrChip(context),
        if (hasDuration) _buildDurationChip(context),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              _buildTitle(context),
              if (dialog?.topics?.name != null) _buildTopicRow(context),
            ],
          ),
          _buildMetaRow(context),
        ],
      ),
    );
  }

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
              _buildThumbnail(context),
              Expanded(child: _buildCardContent(context)),
            ],
          ),
        ),
      ),
    );
  }
}
