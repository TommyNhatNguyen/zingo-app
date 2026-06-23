import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  static final SpeechToText instance = SpeechToText();

  static Future<bool> initialize({
    required Function(SpeechRecognitionError) onError,
    required Function(String) onStatus,
    List<SpeechConfigOption> options = const [],
  }) async {
    return await instance.initialize(
      onError: (error) => onError(error),
      onStatus: (status) => onStatus(status),
      options: options,
    );
  }

  static Future<void> stop() async {
    await instance.stop();
  }
}
