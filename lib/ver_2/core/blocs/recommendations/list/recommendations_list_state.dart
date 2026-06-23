import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/journey.dart';

class RecommendationsListState extends Equatable {
  final JourneyResponse? data;
  final RequestStatus requestStatus;
  final String? error;

  const RecommendationsListState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory RecommendationsListState.initial() {
    return const RecommendationsListState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  bool get hasMore {
    if (data == null) return false;
    return (data!.meta.page * data!.meta.limit) < data!.meta.total;
  }

  RecommendationsListState copyWith({
    JourneyResponse? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return RecommendationsListState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
