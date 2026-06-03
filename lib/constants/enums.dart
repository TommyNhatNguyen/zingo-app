import 'package:flutter/material.dart';

enum RequestStatus {
  initial,
  loading,
  loadingMore,
  success,
  error;

  String get label {
    switch (this) {
      case RequestStatus.initial:
        return 'Initial';
      case RequestStatus.loading:
        return 'Loading';
      case RequestStatus.loadingMore:
        return 'Loading More';
      case RequestStatus.success:
        return 'Success';
      case RequestStatus.error:
        return 'Error';
    }
  }
}

enum EnglishLevel {
  A1,
  A2,
  B1,
  B2,
  C1,
  C2;

  String get value {
    switch (this) {
      case EnglishLevel.A1:
        return 'A1';
      case EnglishLevel.A2:
        return 'A2';
      case EnglishLevel.B1:
        return 'B1';
      case EnglishLevel.B2:
        return 'B2';
      case EnglishLevel.C1:
        return 'C1';
      case EnglishLevel.C2:
        return 'C2';
    }
  }

  String get label {
    switch (this) {
      case EnglishLevel.A1:
        return 'Beginner';
      case EnglishLevel.A2:
        return 'Pre-intermediate/Elementary';
      case EnglishLevel.B1:
        return 'Intermediate';
      case EnglishLevel.B2:
        return 'Upper Intermediate';
      case EnglishLevel.C1:
        return 'Advanced';
      case EnglishLevel.C2:
        return 'Proficiency/Mastery';
    }
  }

  String get description {
    switch (this) {
      case EnglishLevel.A1:
        return 'Can use basic phrases, introduce themselves, and ask simple questions.';
      case EnglishLevel.A2:
        return 'Communicates in simple, routine tasks and describes familiar matters.';
      case EnglishLevel.B1:
        return 'Understands main points of familiar topics, handles travel situations, and writes simple texts.';
      case EnglishLevel.B2:
        return 'Understands complex text, interacts with some fluency, and produces clear, detailed text.';
      case EnglishLevel.C1:
        return 'Understands long, demanding texts and uses language flexibly for social, academic, and professional purposes.';
      case EnglishLevel.C2:
        return 'Understands almost everything with ease, expresses themselves spontaneously, and writes nuanced, complex texts.';
    }
  }

  String get code {
    switch (this) {
      case EnglishLevel.A1:
        return 'A1';
      case EnglishLevel.A2:
        return 'A2';
      case EnglishLevel.B1:
        return 'B1';
      case EnglishLevel.B2:
        return 'B2';
      case EnglishLevel.C1:
        return 'C1';
      case EnglishLevel.C2:
        return 'C2';
    }
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

enum Speaker {
  ai,
  user;

  String get value {
    switch (this) {
      case Speaker.ai:
        return 'ai';
      case Speaker.user:
        return 'user';
    }
  }

  String get label {
    switch (this) {
      case Speaker.ai:
        return 'AI';
      case Speaker.user:
        return 'User';
    }
  }
}
