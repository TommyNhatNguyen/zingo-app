import 'package:flutter/material.dart';

class NotificationTime {
  final TimeOfDay value;
  final String label;
  final String emoji;

  const NotificationTime({
    required this.value,
    required this.label,
    required this.emoji,
  });

  static const List<NotificationTime> all = [
    NotificationTime(
      value: TimeOfDay(hour: 8, minute: 0),
      label: "Morning · 8:00",
      emoji: "🌅",
    ),
    NotificationTime(
      value: TimeOfDay(hour: 12, minute: 0),
      label: "Afternoon · 12:00",
      emoji: "☀️",
    ),
    NotificationTime(
      value: TimeOfDay(hour: 18, minute: 0),
      label: "Evening · 18:00",
      emoji: "🌆",
    ),
    NotificationTime(
      value: TimeOfDay(hour: 21, minute: 0),
      label: "Night · 21:00",
      emoji: "🌙",
    ),
  ];
}
