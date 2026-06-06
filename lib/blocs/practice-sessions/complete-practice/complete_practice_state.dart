import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/completed_practice_session.dart';

class CompletePracticeState extends Equatable {
  const CompletePracticeState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  final CompletedPracticeSession? data;
  final RequestStatus requestStatus;
  final String? error;

  factory CompletePracticeState.initial() {
    return const CompletePracticeState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  CompletePracticeState copyWith({
    CompletedPracticeSession? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return CompletePracticeState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
