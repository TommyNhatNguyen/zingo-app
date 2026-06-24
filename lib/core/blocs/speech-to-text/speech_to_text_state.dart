import 'package:equatable/equatable.dart';

class SpeechToTextState extends Equatable {
  final bool isEnabled;

  const SpeechToTextState({this.isEnabled = false});

  SpeechToTextState copyWith({bool? isEnabled}) =>
      SpeechToTextState(isEnabled: isEnabled ?? this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}
