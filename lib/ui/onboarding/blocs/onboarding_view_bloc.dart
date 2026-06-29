import 'package:bloc/bloc.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_event.dart';
import 'package:zingo/ui/onboarding/blocs/onboarding_view_state.dart';

class OnboardingViewBloc
    extends Bloc<OnboardingViewEvent, OnboardingViewState> {
  OnboardingViewBloc() : super(OnboardingViewState.initial()) {
    on<OnboardingViewGoToPage>((event, emit) {
      if (event.page < 0 || event.page > (state.totalPage - 1)) return;
      emit(state.copyWith(page: event.page));
    });
    on<OnboardingViewUpdateForm>((event, emit) {
      emit(
        state.copyWith(
          displayName: event.displayName,
          displayLanguage: event.displayLanguage,
          motherLanguage: event.motherLanguage,
          practiceGoalPerDay: event.practiceGoalPerDay,
          notificationTime: event.notificationTime,
        ),
      );
    });
  }
}
