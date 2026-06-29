import 'package:bloc/bloc.dart';
import 'package:zingo/ui/profile-setting/blocs/user_profile_view_event.dart';
import 'package:zingo/ui/profile-setting/blocs/user_profile_view_state.dart';

class UserProfileViewBloc
    extends Bloc<UserProfileViewEvent, UserProfileViewState> {
  UserProfileViewBloc() : super(UserProfileViewState.initial()) {
    on<UserProfileViewUpdateForm>((event, emit) {
      emit(
        state.copyWith(
          displayName: event.displayName,
          displayLanguage: event.displayLanguage,
          motherLanguage: event.motherLanguage,
          englishLevel: event.englishLevel,
          practiceGoal: event.practiceGoal,
          notificationTime: event.notificationTime,
          favoriteTopics: event.favoriteTopics,
        ),
      );
    });
  }
}
