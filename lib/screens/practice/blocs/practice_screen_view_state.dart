import 'package:equatable/equatable.dart';
import 'package:zingo/models/dialog_turn.dart';

enum PracticePhase { idle, listening, awaitingRetry, awaitingContinue, finished, disabled }

class PracticeScreenViewState extends Equatable {
  final List<DialogTurn>? turns;
  final int currentTurnIndex;
  final String? playingDialogTurnID;
  final PracticePhase phase;

  const PracticeScreenViewState({
    this.turns = const [],
    this.currentTurnIndex = 0,
    this.playingDialogTurnID,
    this.phase = PracticePhase.idle,
  });

  PracticeScreenViewState copyWith({
    List<DialogTurn>? turns,
    int? currentTurnIndex,
    String? playingDialogTurnID,
    bool clearPlayingDialogTurnID = false,
    PracticePhase? phase,
  }) {
    return PracticeScreenViewState(
      turns: turns ?? this.turns,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
      playingDialogTurnID: clearPlayingDialogTurnID
          ? null
          : (playingDialogTurnID ?? this.playingDialogTurnID),
      phase: phase ?? this.phase,
    );
  }

  @override
  List<Object?> get props => [
    turns,
    currentTurnIndex,
    playingDialogTurnID,
    phase,
  ];
}
