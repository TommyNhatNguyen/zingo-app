import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_bloc.dart';
import 'package:zingo/blocs/speech-to-text/speech_to_text_state.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';

class PracticeControlBar extends StatelessWidget {
  const PracticeControlBar({
    super.key,
    required this.phase,
    required this.isAudioPlaying,
    required this.recognizedText,
    required this.onToggleSpeaking,
    required this.onContinue,
    required this.onEndTurn,
  });

  final PracticePhase phase;
  final bool isAudioPlaying;
  final ValueListenable<String?> recognizedText;
  final VoidCallback onToggleSpeaking;
  final VoidCallback onContinue;
  final VoidCallback onEndTurn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<SpeechToTextBloc, SpeechToTextState>(
          builder: (context, sttState) => Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            height: 100,
            width: double.infinity,
            child: _buildAction(sttState.isEnabled),
          ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: recognizedText,
          builder: (context, value, _) => Text(value ?? ''),
        ),
      ],
    );
  }

  Widget _buildAction(bool isSpeechEnabled) {
    switch (phase) {
      case PracticePhase.finished:
        return FilledButton(
          onPressed: onEndTurn,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.scoreHigh,
            foregroundColor: AppColors.white,
          ),
          child: const Text('End Turn'),
        );
      case PracticePhase.awaitingContinue:
        return FilledButton(
          onPressed: onContinue,
          child: const Text('Continue'),
        );
      case PracticePhase.idle:
      case PracticePhase.listening:
        final disabled = !isSpeechEnabled || isAudioPlaying;
        return IconButton.filled(
          tooltip: 'Start speaking',
          onPressed: disabled ? null : onToggleSpeaking,
          icon: disabled
              ? const Icon(Icons.mic_off, size: 40)
              : phase == PracticePhase.listening
              ? Lottie.asset(
                  'assets/sound_voice_waves.json',
                  width: 40,
                  height: 40,
                  repeat: true,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.mic, size: 40),
        );
    }
  }
}
