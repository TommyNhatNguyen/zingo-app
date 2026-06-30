import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/domain/models/dialog.dart';

class DialogListState extends Equatable {
  final List<Dialog>? data;
  final PaginationMeta? meta;
  final RequestStatus requestStatus;
  final String? error;
  final List<EnglishLevel> cefrLevels;
  final List<DialogDuration> durations;
  final List<String> topicIds;

  const DialogListState({
    this.data,
    this.meta,
    this.requestStatus = RequestStatus.initial,
    this.error,
    this.cefrLevels = const [],
    this.durations = const [],
    this.topicIds = const [],
  });

  factory DialogListState.initial() {
    return const DialogListState(
      data: [],
      meta: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  DialogListState copyWith({
    List<Dialog>? data,
    PaginationMeta? meta,
    RequestStatus? requestStatus,
    String? error,
    List<EnglishLevel>? cefrLevels,
    List<DialogDuration>? durations,
    List<String>? topicIds,
  }) {
    return DialogListState(
      data: data ?? this.data,
      meta: meta ?? this.meta,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
      cefrLevels: cefrLevels ?? this.cefrLevels,
      durations: durations ?? this.durations,
      topicIds: topicIds ?? this.topicIds,
    );
  }

  @override
  List<Object?> get props => [
    data,
    meta,
    requestStatus,
    error,
    cefrLevels,
    durations,
    topicIds,
  ];
}
