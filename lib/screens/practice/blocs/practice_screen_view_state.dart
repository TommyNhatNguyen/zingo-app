import 'package:equatable/equatable.dart';
import 'package:zingo/models/dialog_turn.dart';

class PracticeScreenViewState extends Equatable {
  final List<DialogTurn>? turns;
  final int currentTurnIndex;
  final String? playingDialogTurnID;
  final bool isListening;
  final bool shouldPlayNextDialogTurn;

  final Map<String, String>? recognizedTexts;
  final bool? isEndTurn;
  final String? error;

  const PracticeScreenViewState({
    this.currentTurnIndex = 0,
    this.turns = const [],
    this.playingDialogTurnID,
    this.recognizedTexts = const {},
    this.isEndTurn = false,
    this.error,
    this.isListening = false,
    this.shouldPlayNextDialogTurn = false,
  });

  PracticeScreenViewState copyWith({
    int? currentTurnIndex,
    String? playingDialogTurnID,
    bool clearPlayingDialogTurnID = false,
    Map<String, String>? recognizedTexts,
    List<DialogTurn>? turns,
    bool? isEndTurn,
    String? error,
    bool? isListening,
    bool? shouldPlayNextDialogTurn,
  }) {
    return PracticeScreenViewState(
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
      playingDialogTurnID: clearPlayingDialogTurnID
          ? null
          : (playingDialogTurnID ?? this.playingDialogTurnID),
      recognizedTexts: recognizedTexts ?? this.recognizedTexts,
      turns: turns ?? this.turns,
      isEndTurn: isEndTurn ?? this.isEndTurn,
      error: error ?? this.error,
      isListening: isListening ?? this.isListening,
      shouldPlayNextDialogTurn:
          shouldPlayNextDialogTurn ?? this.shouldPlayNextDialogTurn,
    );
  }

  @override
  List<Object?> get props => [
    currentTurnIndex,
    playingDialogTurnID,
    recognizedTexts,
    isEndTurn,
    turns,
    error,
    isListening,
    shouldPlayNextDialogTurn,
  ];
}
