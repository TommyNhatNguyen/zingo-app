import 'package:bloc/bloc.dart';
import 'package:zingo/core/blocs/user/update-configuration/user_configuration_update_event.dart';
import 'package:zingo/core/blocs/user/update-configuration/user_configuration_update_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/user_configuration_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class UserConfigurationUpdateBloc
    extends Bloc<UserConfigurationUpdateEvent, UserConfigurationUpdateState> {
  final UserConfigurationRepository _repository;

  UserConfigurationUpdateBloc({UserConfigurationRepository? repository})
      : _repository = repository ??
            UserConfigurationRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(UserConfigurationUpdateState.initial()) {
    on<UserConfigurationUpdateTriggered>(_onTriggered);
  }

  Future<void> _onTriggered(
    UserConfigurationUpdateTriggered event,
    Emitter<UserConfigurationUpdateState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.updateUserConfiguration(event.payload);
    switch (result) {
      case Ok():
        emit(state.copyWith(requestStatus: RequestStatus.success));
      case Error(:final error):
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: error.toString(),
          ),
        );
      case ErrorAPI(:final error):
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: error.error.detail,
          ),
        );
    }
  }
}
