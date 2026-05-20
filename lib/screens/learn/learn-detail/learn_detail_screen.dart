import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';

class LearnDetailScreen extends StatefulWidget {
  final String id;

  const LearnDetailScreen({super.key, required this.id});

  @override
  State<LearnDetailScreen> createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends State<LearnDetailScreen> {
  PracticeMode _selectedMode = PracticeMode.freeSpeak;

  void _onModeSelected(PracticeMode mode) {
    setState(() => _selectedMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {},
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
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.heart_broken_outlined),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            automaticallyImplyActions: false,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  Image.asset(
                    "assets/default-fallback-image.png",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Chip(
                      avatar: Icon(Icons.star_border, color: AppColors.xp),
                      label: Text(
                        'cafe & food',
                        style: TextStyle(color: AppColors.xp),
                      ),
                      backgroundColor: AppColors.highlightContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Ordering coffee at a busy cafe"),
                  Text(
                    "A crowded morning cafe. The barista is friendly but rushed.",
                  ),
                  Transform.translate(
                    offset: Offset(-3, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Chip(label: Text("Beginner")),
                        Chip(label: Text("2 min")),
                        Chip(label: Text("5 turns")),
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
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(children: [Text("Last"), Text("78")]),
                              const SizedBox(width: 16),
                              Column(children: [Text("Best"), Text("78")]),
                            ],
                          ),
                        ),
                        Chip(
                          backgroundColor: AppColors.primaryContainer,
                          avatar: Icon(Icons.add_circle),
                          label: Row(children: [Text("+7"), Text("3 tries")]),
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
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textOnHighlight),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
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
                onPressed: () {},
                icon: const Icon(Icons.mic_outlined),
                label: const Text("Start practice"),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.white,
                  elevation: 4,
                  shadowColor: AppColors.accentLight.withAlpha(150),
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
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
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
        const SizedBox(height: 4),
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
            Text("Practice mode".toUpperCase()),
            Text("What's the differences?"),
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
                            Text(mode.label),
                            Text(mode.description),
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
