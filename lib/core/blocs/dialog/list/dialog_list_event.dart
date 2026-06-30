import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';

class DialogListEvent extends Equatable {
  const DialogListEvent();

  @override
  List<Object?> get props => [];
}

class DialogListStarted extends DialogListEvent {
  const DialogListStarted();
}

class DialogListFiltersChanged extends DialogListEvent {
  final List<EnglishLevel> cefrLevels;
  final List<DialogDuration> durations;
  final List<String> topicIds;

  const DialogListFiltersChanged({
    required this.cefrLevels,
    required this.durations,
    required this.topicIds,
  });

  @override
  List<Object?> get props => [cefrLevels, durations, topicIds];
}

class DialogListFetchMoreEvent extends DialogListEvent {
  const DialogListFetchMoreEvent();
}

class DialogListRefreshEvent extends DialogListEvent {
  const DialogListRefreshEvent();
}
