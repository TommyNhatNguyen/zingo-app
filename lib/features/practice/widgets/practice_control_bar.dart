import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/features/practice/blocs/practice_screen_view_state.dart';

class PracticeControlBar extends StatelessWidget {
  const PracticeControlBar({
    super.key,
    required this.phase,
    required this.onToggleSpeaking,
    required this.onContinue,
    required this.onEndTurn,
  });

  final PracticePhase phase;
  final VoidCallback onToggleSpeaking;
  final VoidCallback onContinue;
  final VoidCallback onEndTurn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          height: 100,
          width: double.infinity,
          child: _buildAction(),
        ),
      ],
    );
  }

  Widget _buildAction() {
    switch (phase) {
      case PracticePhase.disabled:
        return IconButton.filled(
          tooltip: 'Start speaking',
          onPressed: null,
          icon: const Icon(Icons.mic_off, size: 40),
        );
      case PracticePhase.awaitingRetry:
        return IconButton.filled(
          tooltip: 'Retry',
          onPressed: onToggleSpeaking,
          icon: const Icon(Icons.refresh, size: 40),
        );
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
        return IconButton.filled(
          tooltip: 'Start speaking',
          onPressed: onToggleSpeaking,
          icon: const Icon(Icons.mic, size: 40),
        );
      case PracticePhase.listening:
        return IconButton.filled(
          tooltip: 'Start speaking',
          onPressed: onToggleSpeaking,
          icon: Lottie.asset(
            'assets/sound_voice_waves.json',
            width: 40,
            height: 40,
            repeat: true,
            fit: BoxFit.cover,
          ),
        );
    }
  }
}
