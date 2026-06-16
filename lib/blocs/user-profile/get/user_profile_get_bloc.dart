import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zingo/blocs/user-profile/get/user_profile_get_event.dart';
import 'package:zingo/blocs/user-profile/get/user_profile_get_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/user_profile_service.dart';

class UserProfileGetBloc
    extends Bloc<UserProfileGetEvent, UserProfileGetState> {
  final _service = UserProfileService();

  UserProfileGetBloc() : super(UserProfileGetState.initial()) {
    on<UserProfileGetFetched>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final result = await _service.getById(event.userId);
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
