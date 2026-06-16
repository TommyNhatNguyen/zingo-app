import 'package:bloc/bloc.dart';
import 'package:zingo/screens/users/blocs/user_profile_view_event.dart';
import 'package:zingo/screens/users/blocs/user_profile_view_state.dart';

class UserProfileViewBloc extends Bloc<UserProfileViewEvent, UserProfileViewState> {
  UserProfileViewBloc() : super(UserProfileViewState.initial()) {
    on<UserProfileViewFetched>((event, emit) {
      // TODO: implement event handler
    });
  }
}