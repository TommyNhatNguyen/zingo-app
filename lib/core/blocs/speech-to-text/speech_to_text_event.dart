import 'package:equatable/equatable.dart';

abstract class SpeechToTextEvent extends Equatable {
  const SpeechToTextEvent();

  @override
  List<Object?> get props => [];
}

class SpeechToTextInitializeEvent extends SpeechToTextEvent {
  const SpeechToTextInitializeEvent();
}
