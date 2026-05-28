import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_event.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';

class PracticeScreenBloc
    extends Bloc<PracticeScreenEvent, PracticeScreenViewState> {
  PracticeScreenBloc() : super(const PracticeScreenViewState()) {
    on<PracticeScreenInitializeEvent>(_onInitialize);
    on<PracticeScreenChangeEvent>(_onChange);
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
        currentTurn: event.payload.currentTurn,
        playingDialogTurnID: event.payload.playingDialogTurnID,
        audioFiles: event.payload.audioFiles,
        recognizedTexts: event.payload.recognizedTexts,
        totalTurns: event.payload.totalTurns,
        turns: event.payload.turns,
        isEndTurn: event.payload.isEndTurn,
        error: event.payload.error,
        recognizedText: event.payload.recognizedText,
        speechEnabled: event.payload.speechEnabled,
        isListening: event.payload.isListening,
      ),
    );
  }
}
