import 'package:bloc/bloc.dart';
import 'package:zingo/ui/explore-detail/blocs/learn_detail_view_event.dart';
import 'package:zingo/ui/explore-detail/blocs/learn_detail_view_state.dart';

class LearnDetailViewBloc
    extends Bloc<LearnDetailViewEvent, LearnDetailViewState> {
  LearnDetailViewBloc() : super(LearnDetailViewState.initial()) {
    on<LearnDetailViewSelectMode>((event, emit) {
      emit(state.copyWith(selectedMode: event.mode));
    });
    on<LearnDetailViewUpdateScroll>((event, emit) {
      emit(
        state.copyWith(
          isAtTop: event.isAtTop,
          isHideNavbar: event.isHideNavbar,
        ),
      );
    });
  }
}
