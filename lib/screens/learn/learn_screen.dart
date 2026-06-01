import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/auth/auth_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_bloc.dart';
import 'package:zingo/blocs/dialog/list/dialog_list_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/screens/learn/widgets/continue_practice_section.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  AuthBloc get authBloc => context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Browse all dialogs"),
                Text(
                  "Practice freely without any filters",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    // In-progress dialogs
                    ContinuePracticeSection(),
                    // Your Favorites
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.favorite),
                            Text(
                              "Your favorites",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        EmptySection(
                          icon: Icon(Icons.favorite),
                          title: Text(
                            "No favorites yet",
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Add your favorite topics to continue practicing",
                            softWrap: true,
                          ),
                          backgroundColor: AppColors.white,
                          borderColor: AppColors.favoriteLight,
                          iconColor: AppColors.favoriteContainer,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Icon(Icons.star),
                                Text("Recommended for you"),
                              ],
                            ),
                            Text("Based on your level and recent practice"),
                          ],
                        ),
                        Card.outlined(
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 16,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "https://fastly.picsum.photos/id/312/200/300.jpg?hmac=bU-4jjrQQCaBqT1RvbRjEZcTQiUWLY5Hp4vYkD5xIKw",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 4,
                                            children: [
                                              Icon(Icons.coffee, size: 16),
                                              Text(
                                                'Coffee',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Describing a headache to a doctor",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            "Quick win — short and confidence-building",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            spacing: 4,
                                            children: [
                                              // Duration
                                              Chip(label: Text("10 turns")),
                                              Chip(
                                                label: Text("Beginner - A1"),
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class EmptySection extends StatelessWidget {
  const EmptySection({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  final Widget? subtitle;
  final Widget icon;
  final Widget title;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(16),
        dashPattern: [10, 5],
        strokeWidth: 2,
        color: borderColor,
      ),
      childOnTop: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 0,
                children: [title, subtitle ?? const SizedBox.shrink()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
