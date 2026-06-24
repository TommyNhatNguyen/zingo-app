import 'package:equatable/equatable.dart';
import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/domain/models/dialog.dart';

class JourneyDialogSlot extends Equatable {
  final String slot_id;
  final int order_index;
  final String status; // "waiting" | "in_progress" | "completed"
  final String? completed_at;
  final Dialog dialog;

  const JourneyDialogSlot({
    required this.slot_id,
    required this.order_index,
    required this.status,
    this.completed_at,
    required this.dialog,
  });

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';

  factory JourneyDialogSlot.fromJson(Map<String, dynamic> json) {
    return JourneyDialogSlot(
      slot_id: json['slot_id'] as String,
      order_index: json['order_index'] as int,
      status: json['status'] as String,
      completed_at: json['completed_at'] as String?,
      dialog: Dialog.fromJson(json['dialog'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
    slot_id,
    order_index,
    status,
    completed_at,
    dialog,
  ];
}

class JourneyChapter extends Equatable {
  final String chapter_id;
  final List<JourneyDialogSlot> dialogs;

  const JourneyChapter({required this.chapter_id, required this.dialogs});

  factory JourneyChapter.fromJson(Map<String, dynamic> json) {
    return JourneyChapter(
      chapter_id: json['chapter_id'] as String,
      dialogs: (json['dialogs'] as List<dynamic>)
          .map((e) => JourneyDialogSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [chapter_id, dialogs];
}

class JourneyResponse extends Equatable {
  final String suggestion_id;
  final List<JourneyChapter> chapters;
  final PaginationMeta meta;

  const JourneyResponse({
    required this.suggestion_id,
    required this.chapters,
    required this.meta,
  });

  factory JourneyResponse.fromJson(Map<String, dynamic> json) {
    return JourneyResponse(
      suggestion_id: json['suggestion_id'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => JourneyChapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  JourneyResponse copyWithChapters(List<JourneyChapter> extra) {
    return JourneyResponse(
      suggestion_id: suggestion_id,
      chapters: [...chapters, ...extra],
      meta: meta,
    );
  }

  @override
  List<Object?> get props => [suggestion_id, chapters, meta];
}
