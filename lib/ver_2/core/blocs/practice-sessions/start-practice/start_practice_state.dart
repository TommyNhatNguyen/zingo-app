import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/practice_session.dart';

class StartPracticeState extends Equatable {
  const StartPracticeState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  final PracticeSession? data;
  final RequestStatus requestStatus;
  final String? error;

  factory StartPracticeState.initial() {
    return const StartPracticeState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  StartPracticeState copyWith({
    PracticeSession? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return StartPracticeState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
