import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zingo/blocs/user/update-configuration/user_configuration_update_event.dart';
import 'package:zingo/blocs/user/update-configuration/user_configuration_update_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/user_service.dart';

class UserConfigurationUpdateBloc
    extends Bloc<UserConfigurationUpdateEvent, UserConfigurationUpdateState> {
  final _service = UserService();

  UserConfigurationUpdateBloc()
      : super(UserConfigurationUpdateState.initial()) {
    on<UserConfigurationUpdateTriggered>(_onTriggered);
  }

  Future<void> _onTriggered(
    UserConfigurationUpdateTriggered event,
    Emitter<UserConfigurationUpdateState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      await _service.updateUserConfiguration(event.userId, event.payload);
      emit(state.copyWith(requestStatus: RequestStatus.success));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          error: e.response?.data?['message']?.toString() ?? e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(requestStatus: RequestStatus.error, error: e.toString()),
      );
    }
  }
}
