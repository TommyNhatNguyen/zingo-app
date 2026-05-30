import 'package:flutter/material.dart';
import 'package:zingo/constants/topics.dart';
import 'package:zingo/screens/onboarding/widgets/profile_page.dart';
import 'package:zingo/widgets/card_select.dart';

class InterestTopicsPage extends StatefulWidget {
  const InterestTopicsPage({
    super.key,
    this.selectedTopics,
    required this.onSelect,
  });

  final Set<String>? selectedTopics;
  final ValueChanged<TopicCategory> onSelect;

  @override
  _InterestTopicsPageState createState() => _InterestTopicsPageState();
}

class _InterestTopicsPageState extends State<InterestTopicsPage> {
  void _toggleTopic(TopicCategory cat) {
    setState(() {
      if (widget.selectedTopics?.contains(cat.code) ?? false) {
        widget.selectedTopics?.remove(cat.code);
      } else {
        widget.selectedTopics?.add(cat.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      emoji: "💬",
      title: "What topics interest you?",
      description: "Pick as many as you like. We'll personalise your dialogs.",
      child: Expanded(
        child: GridView.count(
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
          crossAxisCount: 2,
          children: TopicCategory.all
              .map(
                (cat) => CardSelect(
                  emoji: cat.emoji,
                  label: cat.name,
                  isSelected:
                      widget.selectedTopics?.contains(cat.code) ?? false,
                  onTap: () => _toggleTopic(cat),
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  labelMaxLines: 2,
                  checkIconSize: 16,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
