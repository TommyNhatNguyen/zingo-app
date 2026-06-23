import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/practice-sessions/complete_session_payload.dart';

class CompletePracticeEvent extends Equatable {
  const CompletePracticeEvent();

  @override
  List<Object?> get props => [];
}

class CompletePracticeSubmit extends CompletePracticeEvent {
  final CompleteSessionPayload payload;

  const CompletePracticeSubmit({required this.payload});

  @override
  List<Object?> get props => [payload];
}
