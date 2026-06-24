import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;
import 'package:zingo/ver_2/utils/capitalize_util.dart';

class TopicCard extends StatelessWidget {
  final dialog_model.Dialog? dialog;

  const TopicCard({super.key, this.dialog});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/learn/${dialog?.id}');
      },
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primaryContainer,
                  image: DecorationImage(
                    image:
                        dialog?.thumbnail_url == null ||
                            dialog?.thumbnail_url?.isEmpty == true
                        ? AssetImage("assets/default-fallback-image.png")
                        : CachedNetworkImageProvider(
                            dialog?.thumbnail_url ?? "",
                          ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
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
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.folder_open_rounded,
                        color: AppColors.textOnHighlight,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          CapitalizeUtil.capitalize(
                            text:
                                dialog?.topics?.name ?? dialog?.title ?? "N/A",
                          ),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dialog?.title ?? dialog?.description ?? "N/A",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
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
