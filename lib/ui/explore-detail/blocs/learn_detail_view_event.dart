import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';

sealed class LearnDetailViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LearnDetailViewSelectMode extends LearnDetailViewEvent {
  final PracticeMode mode;

  LearnDetailViewSelectMode({required this.mode});

  @override
  List<Object?> get props => [mode];
}

class LearnDetailViewUpdateScroll extends LearnDetailViewEvent {
  final bool? isAtTop;
  final bool? isHideNavbar;

  LearnDetailViewUpdateScroll({this.isAtTop, this.isHideNavbar});

  @override
  List<Object?> get props => [isAtTop, isHideNavbar];
}
