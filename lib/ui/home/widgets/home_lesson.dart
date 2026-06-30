enum HomeLessonState { completed, nextUp, locked }

class HomeLesson {
  const HomeLesson({
    required this.id,
    required this.slotId,
    required this.number,
    required this.title,
    required this.state,
    this.level,
    this.turns,
    this.durationMin,
    this.xpGain,
  });

  final String id;
  final String slotId;
  final int number;
  final String title;
  final HomeLessonState state;
  final String? level;
  final int? turns;
  final int? durationMin;
  final int? xpGain;
}
