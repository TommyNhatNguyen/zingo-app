import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/journey.dart';

class JourneyState extends Equatable {
  final List<JourneyChapter> chapters;
  final PaginationMeta? meta;
  final RequestStatus requestStatus;
  final String? error;

  const JourneyState({
    this.chapters = const [],
    this.meta,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory JourneyState.initial() => const JourneyState();

  bool get hasMore {
    if (meta == null) return false;
    return meta!.page < meta!.totalPages;
  }

  /// First chapter that still has at least one uncompleted slot.
  /// Falls back to the last chapter when the user has finished everything.
  JourneyChapter? get currentChapter {
    for (final chapter in chapters) {
      final allDone = chapter.dialogs.every((s) => s.isCompleted);
      if (!allDone) return chapter;
    }
    return chapters.isNotEmpty ? chapters.last : null;
  }

  JourneyState copyWith({
    List<JourneyChapter>? chapters,
    PaginationMeta? meta,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return JourneyState(
      chapters: chapters ?? this.chapters,
      meta: meta ?? this.meta,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [chapters, meta, requestStatus, error];
}
