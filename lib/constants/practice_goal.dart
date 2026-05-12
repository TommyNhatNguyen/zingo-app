class PracticeGoal {
  final int value;
  final String label;
  final String emoji;
  final String description;

  const PracticeGoal({
    required this.value,
    required this.label,
    required this.emoji,
    required this.description,
  });

  static const List<PracticeGoal> all = [
    PracticeGoal(
      value: 1,
      label: "1 dialog",
      emoji: "🌱",
      description: "Casual · ~2 min",
    ),
    PracticeGoal(
      value: 3,
      label: "3 dialogs",
      emoji: "🌿",
      description: "Regular · ~10 min",
    ),
    PracticeGoal(
      value: 5,
      label: "5 dialogs",
      emoji: "🌳",
      description: "Committed · ~15 min",
    ),
    PracticeGoal(
      value: 10,
      label: "10 dialogs",
      emoji: "🔥",
      description: "Intensive · ~30 min",
    ),
  ];
}
