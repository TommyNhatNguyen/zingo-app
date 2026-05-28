import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';

class PracticeScreenBloc
    extends Bloc<PracticeScreenEvent, PracticeScreenViewState> {
  PracticeScreenBloc() : super(const PracticeScreenViewState()) {
    on<PracticeScreenInitializeEvent>(_onInitialize);
    on<PracticeScreenChangeEvent>(_onChange);
    on<PracticeScreenInsertDialogTurnEvent>(_onInsertDialogTurn);
    on<PracticeScreenLoadDialogTurnsEvent>(_onLoadDialogTurns);
    on<PracticeScreenPlayDialogTurnAudioEvent>(_onPlayDialogTurnAudio);
    on<PracticeScreenStartListeningEvent>(_onStartListening);
    on<PracticeScreenStopListeningEvent>(_onStopListening);
    on<PracticeScreenRecognizedTextEvent>(_onRecognizedText);
  }

  void _onInitialize(
    PracticeScreenInitializeEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(const PracticeScreenViewState());
  }

  void _onChange(
    PracticeScreenChangeEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(
      state.copyWith(
        currentTurnIndex: event.payload.currentTurnIndex,
        playingDialogTurnID: event.payload.playingDialogTurnID,
        recognizedTexts: event.payload.recognizedTexts,
        turns: event.payload.turns,
        isEndTurn: event.payload.isEndTurn,
        error: event.payload.error,
        isListening: event.payload.isListening,
      ),
    );
  }

  void _onLoadDialogTurns(
    PracticeScreenLoadDialogTurnsEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(state.copyWith(turns: event.turns));
  }

  void _onPlayDialogTurnAudio(
    PracticeScreenPlayDialogTurnAudioEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(
      state.copyWith(
        playingDialogTurnID: event.turn?.id,
        clearPlayingDialogTurnID: event.clearPlayingDialogTurnID,
      ),
    );
  }

  void _onInsertDialogTurn(
    PracticeScreenInsertDialogTurnEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(state.copyWith(currentTurnIndex: event.currentTurnIndex));
  }

  void _onStartListening(
    PracticeScreenStartListeningEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(state.copyWith(isListening: true));
  }

  void _onStopListening(
    PracticeScreenStopListeningEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(state.copyWith(isListening: false));
  }

  void _onRecognizedText(
    PracticeScreenRecognizedTextEvent event,
    Emitter<PracticeScreenViewState> emit,
  ) {
    emit(
      state.copyWith(
        recognizedTexts: {
          ...?state.recognizedTexts,
          event.dialogTurnId: event.recognizedText,
        },
      ),
    );
  }
}
