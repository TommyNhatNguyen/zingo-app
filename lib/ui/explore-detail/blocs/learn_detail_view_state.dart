import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';

class LearnDetailViewState extends Equatable {
  final PracticeMode selectedMode;
  final bool isHideNavbar;
  final bool isAtTop;

  const LearnDetailViewState({
    required this.selectedMode,
    required this.isHideNavbar,
    required this.isAtTop,
  });

  factory LearnDetailViewState.initial() => const LearnDetailViewState(
    selectedMode: PracticeMode.readAloud,
    isHideNavbar: false,
    isAtTop: true,
  );

  LearnDetailViewState copyWith({
    PracticeMode? selectedMode,
    bool? isHideNavbar,
    bool? isAtTop,
  }) {
    return LearnDetailViewState(
      selectedMode: selectedMode ?? this.selectedMode,
      isHideNavbar: isHideNavbar ?? this.isHideNavbar,
      isAtTop: isAtTop ?? this.isAtTop,
    );
  }

  @override
  List<Object?> get props => [selectedMode, isHideNavbar, isAtTop];
}
