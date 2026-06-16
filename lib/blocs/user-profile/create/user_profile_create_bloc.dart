import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zingo/blocs/user-profile/create/user_profile_create_event.dart';
import 'package:zingo/blocs/user-profile/create/user_profile_create_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/user_profile_service.dart';

class UserProfileCreateBloc
    extends Bloc<UserProfileCreateEvent, UserProfileCreateState> {
  final _service = UserProfileService();

  UserProfileCreateBloc() : super(UserProfileCreateState.initial()) {
    on<UserProfileCreateTrigger>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));

        final result = await _service.onboarding(event.payload);

        emit(
          state.copyWith(requestStatus: RequestStatus.success, data: result),
        );
      } on DioException catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.response?.data?['message']?.toString() ?? e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.toString(),
          ),
        );
      }
    });
  }
}
