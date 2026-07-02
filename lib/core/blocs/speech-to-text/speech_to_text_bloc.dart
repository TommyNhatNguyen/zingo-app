import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_event.dart';
import 'package:zingo/core/blocs/speech-to-text/speech_to_text_state.dart';
import 'package:zingo/utils/speech_to_text_service.dart';

class SpeechToTextBloc extends Bloc<SpeechToTextEvent, SpeechToTextState> {
  SpeechToTextBloc() : super(const SpeechToTextState()) {
    on<SpeechToTextInitializeEvent>(_onInitialize);
  }

  Future<void> _onInitialize(
    SpeechToTextInitializeEvent event,
    Emitter<SpeechToTextState> emit,
  ) async {
    if (SpeechToTextService.instance.isAvailable) {
      emit(state.copyWith(isEnabled: true));
      return;
    }

    final enabled = await SpeechToTextService.instance.initialize(
      onError: (_) {},
      onStatus: (_) {},
      debugLogging: true,
    );

    if (enabled) {
      print("SpeechToTextBloc: isEnabled: $enabled");
      print("--------------------------------");
      emit(state.copyWith(isEnabled: enabled));
    }
  }
}
