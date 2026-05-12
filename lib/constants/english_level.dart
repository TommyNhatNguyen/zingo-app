
class EnglishLevel {
  final String code;
  final String name;
  final String description;

  const EnglishLevel({
    required this.code,
    required this.name,
    required this.description,
  });

  static const List<EnglishLevel> all = [
    EnglishLevel(
      code: 'a1',
      name: 'Beginner',
      description:
          'Can use basic phrases, introduce themselves, and ask simple questions.',
    ),
    EnglishLevel(
      code: 'a2',
      name: 'Pre-intermediate/Elementary',
      description:
          'Communicates in simple, routine tasks and describes familiar matters.',
    ),
    EnglishLevel(
      code: 'b1',
      name: 'Intermediate',
      description:
          'Understands main points of familiar topics, handles travel situations, and writes simple texts.',
    ),
    EnglishLevel(
      code: 'b2',
      name: 'Upper Intermediate',
      description:
          'Understands complex text, interacts with some fluency, and produces clear, detailed text.',
    ),
    EnglishLevel(
      code: 'c1',
      name: 'Advanced',
      description:
          'Understands long, demanding texts and uses language flexibly for social, academic, and professional purposes.',
    ),
    EnglishLevel(
      code: 'c2',
      name: 'Proficiency/Mastery',
      description:
          'Understands almost everything with ease, expresses themselves spontaneously, and writes nuanced, complex texts.',
    ),
  ];
}

// A1 (Beginner): Can use basic phrases, introduce themselves, and ask simple questions.
// A2 (Pre-intermediate/Elementary): Communicates in simple, routine tasks and describes familiar matters.
// B1 (Intermediate): Understands main points of familiar topics, handles travel situations, and writes simple texts.
// B2 (Upper Intermediate): Understands complex text, interacts with some fluency, and produces clear, detailed text.
// C1 (Advanced): Understands long, demanding texts and uses language flexibly for social, academic, and professional purposes.
// C2 (Proficiency/Mastery): Understands almost everything with ease, expresses themselves spontaneously, and writes nuanced, complex texts.
