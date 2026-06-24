import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/models/dialog.dart' as dialog_model;
import 'package:zingo/ver_2/ui/explore-detail/widgets/favorite_dialog_trigger.dart';
import 'package:zingo/ver_2/utils/capitalize_util.dart';

class LearnDetailAppBar extends StatefulWidget {
  const LearnDetailAppBar({super.key, this.data, this.isAtTop = true});

  final dialog_model.Dialog? data;
  final bool isAtTop;

  @override
  _LearnDetailAppBarState createState() => _LearnDetailAppBarState();
}

class _LearnDetailAppBarState extends State<LearnDetailAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 8),
      actions: [
        FavoriteDialogTrigger(
          key: ObjectKey(widget.data),
          dialogId: widget.data?.id ?? '',
          isFavorite: widget.data?.is_favorite ?? false,
        ),
      ],
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      elevation: 0.5,
      shadowColor: AppColors.background.withAlpha(200),
      surfaceTintColor: AppColors.primaryContainer,
      backgroundColor: AppColors.background,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      snap: false,
      title: AnimatedOpacity(
        opacity: widget.isAtTop ? 0 : 1,
        duration: Duration(milliseconds: 300),
        child: Text(
          CapitalizeUtil.capitalize(text: widget.data?.title ?? ''),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.data?.thumbnail_url ?? '',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              placeholder: (context, url) => Skeletonizer(
                enabled: true,
                child: Container(color: AppColors.background),
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/default-fallback-image.png",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Chip(
                avatar: Icon(Icons.folder_open_rounded),
                label: Text(widget.data?.topics?.name ?? ''),
                backgroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
