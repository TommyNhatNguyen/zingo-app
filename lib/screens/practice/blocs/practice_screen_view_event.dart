import 'package:equatable/equatable.dart';
import 'package:zingo/screens/practice/blocs/practice_screen_view_state.dart';

class PracticeScreenEvent extends Equatable {
  const PracticeScreenEvent();

  @override
  List<Object?> get props => [];
}

class PracticeScreenInitializeEvent extends PracticeScreenEvent {
  const PracticeScreenInitializeEvent();
}

/// Carry the full desired state — callers use bloc.state.copyWith(...) to build it.
class PracticeScreenChangeEvent extends PracticeScreenEvent {
  final PracticeScreenViewState payload;

  const PracticeScreenChangeEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}
