enum RequestStatus {
  initial,
  loading,
  success,
  error;

  String get label {
    switch (this) {
      case RequestStatus.initial:
        return 'Initial';
      case RequestStatus.loading:
        return 'Loading';
      case RequestStatus.success:
        return 'Success';
      case RequestStatus.error:
        return 'Error';
    }
  }
}

enum EnglishLevel {
  a1,
  a2,
  b1,
  b2,
  c1,
  c2;

  String get value {
    switch (this) {
      case EnglishLevel.a1:
        return 'A1';
      case EnglishLevel.a2:
        return 'A2';
      case EnglishLevel.b1:
        return 'B1';
      case EnglishLevel.b2:
        return 'B2';
      case EnglishLevel.c1:
        return 'C1';
      case EnglishLevel.c2:
        return 'C2';
    }
  }

  String get label {
    switch (this) {
      case EnglishLevel.a1:
        return 'Beginner';
      case EnglishLevel.a2:
        return 'Pre-intermediate/Elementary';
      case EnglishLevel.b1:
        return 'Intermediate';
      case EnglishLevel.b2:
        return 'Upper Intermediate';
      case EnglishLevel.c1:
        return 'Advanced';
      case EnglishLevel.c2:
        return 'Proficiency/Mastery';
    }
  }

  String get description {
    switch (this) {
      case EnglishLevel.a1:
        return 'Can use basic phrases, introduce themselves, and ask simple questions.';
      case EnglishLevel.a2:
        return 'Communicates in simple, routine tasks and describes familiar matters.';
      case EnglishLevel.b1:
        return 'Understands main points of familiar topics, handles travel situations, and writes simple texts.';
      case EnglishLevel.b2:
        return 'Understands complex text, interacts with some fluency, and produces clear, detailed text.';
      case EnglishLevel.c1:
        return 'Understands long, demanding texts and uses language flexibly for social, academic, and professional purposes.';
      case EnglishLevel.c2:
        return 'Understands almost everything with ease, expresses themselves spontaneously, and writes nuanced, complex texts.';
    }
  }

  String get code {
    switch (this) {
      case EnglishLevel.a1:
        return 'A1';
      case EnglishLevel.a2:
        return 'A2';
      case EnglishLevel.b1:
        return 'B1';
      case EnglishLevel.b2:
        return 'B2';
      case EnglishLevel.c1:
        return 'C1';
      case EnglishLevel.c2:
        return 'C2';
    }
  }
}
