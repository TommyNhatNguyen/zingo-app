import 'package:equatable/equatable.dart';

abstract class PopularDialogsEvent extends Equatable {
  const PopularDialogsEvent();

  @override
  List<Object?> get props => [];
}

class PopularDialogsFetchNextPageEvent extends PopularDialogsEvent {
  const PopularDialogsFetchNextPageEvent();
}

class PopularDialogsRefreshEvent extends PopularDialogsEvent {
  const PopularDialogsRefreshEvent();
}
