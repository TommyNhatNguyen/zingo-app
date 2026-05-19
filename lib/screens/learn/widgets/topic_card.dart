import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;

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
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
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
            Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
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
                            dialog?.topics?.name ?? dialog?.title ?? "N/A",
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
            ),
          ],
        ),
      ),
    );
  }
}
