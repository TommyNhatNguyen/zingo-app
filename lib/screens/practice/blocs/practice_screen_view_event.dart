import 'package:equatable/equatable.dart';
import 'package:zingo/models/dialog_turn.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';

class PracticeScreenEvent extends Equatable {
  const PracticeScreenEvent();

  @override
  List<Object?> get props => [];
}

class PracticeScreenInitializeEvent extends PracticeScreenEvent {
  const PracticeScreenInitializeEvent();
}

/// Carry the full desired state — callers use bloc.state.copyWith(...) to build it.
class PracticeScreenChangeEvent extends PracticeScreenEvent {
  final PracticeScreenViewState payload;

  const PracticeScreenChangeEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class PracticeScreenLoadDialogTurnsEvent extends PracticeScreenEvent {
  final List<DialogTurn> turns;

  const PracticeScreenLoadDialogTurnsEvent({required this.turns});

  @override
  List<Object?> get props => [turns];
}

class PracticeScreenInsertDialogTurnEvent extends PracticeScreenEvent {
  final DialogTurn turn;
  final int currentTurnIndex;

  const PracticeScreenInsertDialogTurnEvent({
    required this.turn,
    required this.currentTurnIndex,
  });

  @override
  List<Object?> get props => [turn, currentTurnIndex];
}

class PracticeScreenPlayDialogTurnAudioEvent extends PracticeScreenEvent {
  final DialogTurn? turn;
  final bool clearPlayingDialogTurnID;

  const PracticeScreenPlayDialogTurnAudioEvent({
    this.turn,
    this.clearPlayingDialogTurnID = false,
  });

  @override
  List<Object?> get props => [turn, clearPlayingDialogTurnID];
}

class PracticeScreenStartListeningEvent extends PracticeScreenEvent {
  const PracticeScreenStartListeningEvent();
}

class PracticeScreenStopListeningEvent extends PracticeScreenEvent {
  const PracticeScreenStopListeningEvent();
}
