import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zingo/models/dialog_turn.dart';

class PracticeScreenViewState extends Equatable {
  final int? currentTurn;
  final List<DialogTurn>? turns;
  final String? playingDialogTurnID;
  final Map<String, File>? audioFiles;
  final Map<String, String>? recognizedTexts;
  final int? totalTurns;
  final bool? isEndTurn;
  final String? error;
  final String recognizedText;
  final bool speechEnabled;
  final bool isListening;

  const PracticeScreenViewState({
    this.currentTurn = 0,
    this.totalTurns = 0,
    this.turns = const [],
    this.playingDialogTurnID,
    this.audioFiles = const {},
    this.recognizedTexts = const {},
    this.isEndTurn = false,
    this.error,
    this.recognizedText = '',
    this.speechEnabled = false,
    this.isListening = false,
  });

  PracticeScreenViewState copyWith({
    int? currentTurn,
    String? playingDialogTurnID,
    bool clearPlayingDialogTurnID = false,
    Map<String, File>? audioFiles,
    Map<String, String>? recognizedTexts,
    int? totalTurns,
    List<DialogTurn>? turns,
    bool? isEndTurn,
    String? error,
    String? recognizedText,
    bool? speechEnabled,
    bool? isListening,
  }) {
    return PracticeScreenViewState(
      currentTurn: currentTurn ?? this.currentTurn,
      playingDialogTurnID: clearPlayingDialogTurnID
          ? null
          : (playingDialogTurnID ?? this.playingDialogTurnID),
      audioFiles: audioFiles ?? this.audioFiles,
      recognizedTexts: recognizedTexts ?? this.recognizedTexts,
      totalTurns: totalTurns ?? this.totalTurns,
      turns: turns ?? this.turns,
      isEndTurn: isEndTurn ?? this.isEndTurn,
      error: error ?? this.error,
      recognizedText: recognizedText ?? this.recognizedText,
      speechEnabled: speechEnabled ?? this.speechEnabled,
      isListening: isListening ?? this.isListening,
    );
  }

  @override
  List<Object?> get props => [
    currentTurn,
    playingDialogTurnID,
    audioFiles,
    recognizedTexts,
    isEndTurn,
    totalTurns,
    turns,
    error,
    recognizedText,
    speechEnabled,
    isListening,
  ];
}
