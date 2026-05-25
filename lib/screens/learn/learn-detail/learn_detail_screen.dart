import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_bloc.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_event.dart';
import 'package:zingo/blocs/dialog/detail/dialog_detail_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/dialog/dialog_detail_payload.dart';
import 'package:zingo/screens/learn/widgets/favorite_dialog_trigger.dart';
import 'package:zingo/utils/capitalize_util.dart';

class LearnDetailScreen extends StatefulWidget {
  final String id;

  const LearnDetailScreen({super.key, required this.id});

  @override
  State<LearnDetailScreen> createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends State<LearnDetailScreen> {
  PracticeMode _selectedMode = PracticeMode.freeSpeak;
  final ScrollController _scrollController = ScrollController();
  bool _isHideNavbar = false;
  bool _isAtTop = true;
  DialogDetailBloc get bloc => context.read<DialogDetailBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 180) {
        setState(() => _isAtTop = true);
      } else {
        setState(() => _isAtTop = false);
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isHideNavbar) setState(() => _isHideNavbar = true);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isHideNavbar) setState(() => _isHideNavbar = false);
      }
    });
    bloc.add(
      DialogDetailFetchEvent(payload: DialogDetailPayload(id: widget.id)),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onModeSelected(PracticeMode mode) {
    setState(() => _selectedMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DialogDetailBloc, DialogDetailState>(
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.error) {
          Toastification().show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: const Text('Error'),
            description: Text(state.error ?? 'An error occurred'),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        final hasPracticeSession = state.data?.practice_session_id != null;
        return Scaffold(
          body: Skeletonizer(
            enabled: state.requestStatus == RequestStatus.loading,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
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
                            key: ObjectKey(state.data),
                            dialogId: widget.id,
                            initialIsFavorite: state.data?.is_favorite ?? false,
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
                          opacity: _isAtTop ? 0 : 1,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            CapitalizeUtil.capitalize(
                              text: state.data?.title ?? '',
                            ),
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
                                imageUrl: state.data?.thumbnail_url ?? '',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                placeholder: (context, url) => Skeletonizer(
                                  enabled: true,
                                  child: Container(color: AppColors.background),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
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
                                  label: Text(state.data?.topics?.name ?? ''),
                                  backgroundColor: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 16,
                            children: [
                              Text(
                                CapitalizeUtil.capitalize(
                                  text: state.data?.title ?? '',
                                ),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              Text(
                                state.data?.description ?? '',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              Transform.translate(
                                offset: Offset(-3, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 8,
                                  children: [
                                    Chip(label: Text(state.data?.level ?? '')),
                                    Chip(
                                      label: Text(state.data?.duration ?? ''),
                                    ),
                                    Chip(
                                      label: Text(
                                        "${state.data?.conversation_length.toString()} turns",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  spacing: 16,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "LAST",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      letterSpacing: 1.2,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                              ),
                                              Text(
                                                "78",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge
                                                    ?.copyWith(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "BEST",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      letterSpacing: 1.2,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                              ),
                                              Text(
                                                "85",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.highlight,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Chip(
                                      backgroundColor:
                                          AppColors.primaryContainer,
                                      avatar: Icon(
                                        Icons.add_circle,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                      label: Text(
                                        "+7 · 3 tries",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppColors.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PraceticeModeForm(
                                selectedMode: _selectedMode,
                                onModeSelected: _onModeSelected,
                              ),
                              PracticeModePreview(selectedMode: _selectedMode),
                              const HowItWorks(),
                              const YoullBeScoredOn(),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.highlightContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      size: 16,
                                      color: AppColors.highlight,
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppColors.textOnHighlight,
                                              ),
                                          children: [
                                            TextSpan(
                                              text: "Tip: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.highlight,
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  "Speak clearly. Pauses are fine — recording stops only when you tap again.",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transformAlignment: AlignmentGeometry.xy(
                      0,
                      _isHideNavbar ? 1 : 0,
                    ),
                    transform: Matrix4.translationValues(
                      0,
                      _isHideNavbar ? 100 : 0,
                      0,
                    ),
                    curve: Curves.ease,
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              context.pushReplacement(
                                '/practice',
                                extra: {
                                  'practice_session_id':
                                      state.data?.practice_session_id ?? '',
                                  'dialog_id': widget.id,
                                },
                              );
                            },
                            icon: const Icon(Icons.mic_outlined),
                            label: Text(
                              hasPracticeSession
                                  ? "Resume practice"
                                  : "Start practice",
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: hasPracticeSession
                                  ? AppColors.primary
                                  : AppColors.accent,
                              foregroundColor: AppColors.white,
                              elevation: 4,
                              shadowColor: hasPracticeSession
                                  ? AppColors.primaryLight.withAlpha(150)
                                  : AppColors.accentLight.withAlpha(150),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                            children: [
                              TextSpan(text: "${_selectedMode.label} · up to "),
                              TextSpan(
                                text: "+45 XP",
                                style: TextStyle(
                                  color: AppColors.xp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PracticeModePreview extends StatelessWidget {
  const PracticeModePreview({super.key, required PracticeMode selectedMode})
    : _selectedMode = selectedMode;

  final PracticeMode _selectedMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          "PREVIEW · TURN 2",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.man_4_outlined, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Text("What can I get started for you?"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(16),
                    dashPattern: [10, 5],
                    strokeWidth: 2,
                    padding: EdgeInsets.zero,
                    color: AppColors.highlight,
                  ),
                  childOnTop: false,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.highlightContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: AppColors.highlight,
                            ),
                            Text(
                              "SAMPLE REPLY",
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.highlight,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"A small cappuccino, please."',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textOnHighlight,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedMode == PracticeMode.freeSpeak
                              ? "You see this on screen. Say it your way — any natural variation works."
                              : "Read the sample out loud, word for word.",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedMode == PracticeMode.freeSpeak) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      Expanded(
                        child: Text(
                          'Examples of natural replies: "Just a small cappuccino", "Could I get a small cap?", "I\'ll have a cappuccino, small please."',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

enum PracticeMode {
  freeSpeak,
  readAloud;

  String get label => switch (this) {
    PracticeMode.freeSpeak => "Free speak",
    PracticeMode.readAloud => "Read aloud",
  };

  String get description => switch (this) {
    PracticeMode.freeSpeak => "Sample shown - say it your way",
    PracticeMode.readAloud => "Read the sample out loud",
  };

  IconData get icon => switch (this) {
    PracticeMode.freeSpeak => Icons.lightbulb_outline,
    PracticeMode.readAloud => Icons.description,
  };
}

class PraceticeModeForm extends StatefulWidget {
  const PraceticeModeForm({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  final PracticeMode selectedMode;
  final ValueChanged<PracticeMode> onModeSelected;

  @override
  State<PraceticeModeForm> createState() => _PraceticeModeFormState();
}

class _PraceticeModeFormState extends State<PraceticeModeForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PRACTICE MODE",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text("What's the difference?"),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: PracticeMode.values.map((mode) {
            final isSelected = widget.selectedMode == mode;
            return Expanded(
              child: Card.outlined(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: InkWell(
                  onTap: () => widget.onModeSelected(mode),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primaryContainer.withAlpha(100),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                mode.icon,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              mode.label,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              mode.description,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  static const _steps = [
    (
      icon: Icons.headphones,
      title: "Listen & see the sample",
      description: "AI speaks. A scene image and sample reply appear.",
    ),
    (
      icon: Icons.mic_none,
      title: "Say it your way — or read it",
      description: "Tap mic, speak, tap again to stop.",
    ),
    (
      icon: Icons.bar_chart,
      title: "Get instant feedback",
      description: "Scored on 3 dimensions. Re-record any turn.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          "HOW IT WORKS",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: _steps.indexed.expand((entry) {
              final (i, step) = entry;
              return [
                if (i > 0) Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    spacing: 14,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              step.icon,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${i + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              step.description,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class YoullBeScoredOn extends StatelessWidget {
  const YoullBeScoredOn({super.key});

  static const _dimensions = [
    (
      icon: Icons.translate,
      color: Color(0xFF0891B2),
      containerColor: Color(0xFFE0F7FB),
      title: "Grammar",
      tag: "Structure",
      description: "Correct tense, agreement, word order, prepositions.",
      example: "e.g. \"Try 'could I have' — more polite here.\"",
    ),
    (
      icon: Icons.auto_fix_high,
      color: Color(0xFFDB2777),
      containerColor: Color(0xFFFCE7F3),
      title: "Naturalness",
      tag: "Native-like",
      description: "How fluent and idiomatic your phrasing sounds.",
      example: "e.g. \"Skip 'please' mid-sentence — feels more casual.\"",
    ),
    (
      icon: Icons.check,
      color: Color(0xFF22C55E),
      containerColor: Color(0xFFDCFCE7),
      title: "Completeness",
      tag: "Coverage",
      description: "Whether you addressed everything the AI asked.",
      example: "e.g. \"Answered both questions clearly — great.\"",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "YOU'LL BE SCORED ON",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              "3 dimensions · 0–100 each",
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: _dimensions.indexed.expand((entry) {
              final (i, dim) = entry;
              return [
                if (i > 0) Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: dim.containerColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(dim.icon, color: dim.color, size: 20),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dim.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      dim.tag,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: dim.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Text(
                                  dim.description,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: dim.containerColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dim.example,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: dim.color,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            }).toList(),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Score ranges: ",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.xp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...[
                (color: AppColors.scoreLow, label: "0–50"),
                (color: AppColors.scoreMid, label: "51–74"),
                (color: AppColors.primary, label: "75–89"),
                (color: AppColors.scoreHigh, label: "90–100"),
              ].map(
                (range) => Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: range.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      range.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
