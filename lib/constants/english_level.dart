import 'package:zingo/constants/enums.dart' as app_enums;

class EnglishLevel {
  final app_enums.EnglishLevel code;
  final String name;
  final String description;

  const EnglishLevel({
    required this.code,
    required this.name,
    required this.description,
  });

  static const List<EnglishLevel> all = [
    EnglishLevel(
      code: app_enums.EnglishLevel.A1,
      name: 'Beginner',
      description:
          'Can use basic phrases, introduce themselves, and ask simple questions.',
    ),
    EnglishLevel(
      code: app_enums.EnglishLevel.A2,
      name: 'Pre-intermediate/Elementary',
      description:
          'Communicates in simple, routine tasks and describes familiar matters.',
    ),
    EnglishLevel(
      code: app_enums.EnglishLevel.B1,
      name: 'Intermediate',
      description:
          'Understands main points of familiar topics, handles travel situations, and writes simple texts.',
    ),
    EnglishLevel(
      code: app_enums.EnglishLevel.B2,
      name: 'Upper Intermediate',
      description:
          'Understands complex text, interacts with some fluency, and produces clear, detailed text.',
    ),
    EnglishLevel(
      code: app_enums.EnglishLevel.C1,
      name: 'Advanced',
      description:
          'Understands long, demanding texts and uses language flexibly for social, academic, and professional purposes.',
    ),
    EnglishLevel(
      code: app_enums.EnglishLevel.C2,
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
