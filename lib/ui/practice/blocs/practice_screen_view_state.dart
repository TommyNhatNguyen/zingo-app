import 'package:equatable/equatable.dart';
import 'package:zingo/domain/models/dialog_turn.dart';

enum PracticePhase { idle, listening, awaitingRetry, awaitingContinue, finished, disabled }

class PracticeScreenViewState extends Equatable {
  final List<DialogTurn>? turns;
  final int currentTurnIndex;
  final String? playingDialogTurnID;
  final PracticePhase phase;
  final bool isLoadingDialogTurns;

  const PracticeScreenViewState({
    this.turns = const [],
    this.currentTurnIndex = 0,
    this.playingDialogTurnID,
    this.phase = PracticePhase.idle,
    this.isLoadingDialogTurns = true,
  });

  factory PracticeScreenViewState.initial() =>
      const PracticeScreenViewState();

  PracticeScreenViewState copyWith({
    List<DialogTurn>? turns,
    int? currentTurnIndex,
    String? playingDialogTurnID,
    bool clearPlayingDialogTurnID = false,
    PracticePhase? phase,
    bool? isLoadingDialogTurns,
  }) {
    return PracticeScreenViewState(
      turns: turns ?? this.turns,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
      playingDialogTurnID: clearPlayingDialogTurnID
          ? null
          : (playingDialogTurnID ?? this.playingDialogTurnID),
      phase: phase ?? this.phase,
      isLoadingDialogTurns: isLoadingDialogTurns ?? this.isLoadingDialogTurns,
    );
  }

  @override
  List<Object?> get props => [
    turns,
    currentTurnIndex,
    playingDialogTurnID,
    phase,
    isLoadingDialogTurns,
  ];
}
