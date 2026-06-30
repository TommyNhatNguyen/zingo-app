import 'package:equatable/equatable.dart';
import 'package:zingo/domain/models/dialog_turn.dart';
import 'package:zingo/ui/practice/blocs/practice_screen_view_state.dart';

sealed class PracticeScreenEvent extends Equatable {
  const PracticeScreenEvent();

  @override
  List<Object?> get props => [];
}

class PracticeScreenInitializeEvent extends PracticeScreenEvent {
  const PracticeScreenInitializeEvent();
}

class PracticeScreenLoadDialogTurnsEvent extends PracticeScreenEvent {
  final List<DialogTurn> turns;

  const PracticeScreenLoadDialogTurnsEvent({required this.turns});

  @override
  List<Object?> get props => [turns];
}

class PracticeScreenInsertDialogTurnEvent extends PracticeScreenEvent {
  final int currentTurnIndex;

  const PracticeScreenInsertDialogTurnEvent({required this.currentTurnIndex});

  @override
  List<Object?> get props => [currentTurnIndex];
}

class PracticeScreenSetPhaseEvent extends PracticeScreenEvent {
  final PracticePhase phase;

  const PracticeScreenSetPhaseEvent(this.phase);

  @override
  List<Object?> get props => [phase];
}

class PracticeScreenSetPlayingAudioEvent extends PracticeScreenEvent {
  final String? turnId;

  const PracticeScreenSetPlayingAudioEvent({this.turnId});

  @override
  List<Object?> get props => [turnId];
}

class PracticeScreenSetLoadingDialogTurnsEvent extends PracticeScreenEvent {
  final bool isLoading;

  const PracticeScreenSetLoadingDialogTurnsEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}
