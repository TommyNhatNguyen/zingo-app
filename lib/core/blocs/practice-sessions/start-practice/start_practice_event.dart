import 'package:equatable/equatable.dart';
import 'package:zingo/domain/dtos/practice-sessions/create_session_payload.dart';

class StartPracticeEvent extends Equatable {
  const StartPracticeEvent();

  @override
  List<Object?> get props => [];
}

class StartPracticeSubmit extends StartPracticeEvent {
  final CreateSessionPayload payload;

  const StartPracticeSubmit({required this.payload});

  @override
  List<Object?> get props => [payload];
}
