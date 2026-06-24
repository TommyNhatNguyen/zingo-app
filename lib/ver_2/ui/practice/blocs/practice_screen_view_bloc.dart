import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/ver_2/ui/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/ver_2/ui/practice/blocs/practice_screen_view_state.dart';

class PracticeScreenBloc
    extends Bloc<PracticeScreenEvent, PracticeScreenViewState> {
  PracticeScreenBloc() : super(const PracticeScreenViewState()) {
    on<PracticeScreenInitializeEvent>(_onInitialize);
    on<PracticeScreenLoadDialogTurnsEvent>(_onLoadDialogTurns);
    on<PracticeScreenInsertDialogTurnEvent>(_onInsertDialogTurn);
    on<PracticeScreenSetPhaseEvent>(_onSetPhase);
    on<PracticeScreenSetPlayingAudioEvent>(_onSetPlayingAudio);
  }

  void _onInitialize(
    PracticeScreenInitializeEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(const PracticeScreenViewState());
  }

  void _onLoadDialogTurns(
    PracticeScreenLoadDialogTurnsEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(state.copyWith(turns: event.turns));
  }

  void _onInsertDialogTurn(
    PracticeScreenInsertDialogTurnEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(state.copyWith(currentTurnIndex: event.currentTurnIndex));
  }

  void _onSetPhase(
    PracticeScreenSetPhaseEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(state.copyWith(phase: event.phase));
  }

  void _onSetPlayingAudio(
    PracticeScreenSetPlayingAudioEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(
      state.copyWith(
        playingDialogTurnID: event.turnId,
        clearPlayingDialogTurnID: event.turnId == null,
      ),
    );
  }
}
