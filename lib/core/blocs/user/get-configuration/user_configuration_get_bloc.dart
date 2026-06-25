import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/core/blocs/user/get-configuration/user_configuration_get_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/user_configuration_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/models/user_configuration.dart';
import 'package:zingo/domain/models/user_setting.dart';

class UserConfigurationGetBloc
    extends Bloc<UserConfigurationGetEvent, UserConfigurationGetState> {
  final UserConfigurationRepository _repository;

  UserConfigurationGetBloc({UserConfigurationRepository? repository})
    : _repository =
          repository ??
          UserConfigurationRepository(
            apiClientService: ApiClientService(httpClient: dio),
          ),
      super(UserConfigurationGetState.initial()) {
    on<UserConfigurationGetFetched>(_onFetched);
    on<UserConfigurationGetReset>(_onReset);
    on<UserConfigurationGetProfileUpdated>(_onProfileUpdated);
  }

  Future<void> _onFetched(
    UserConfigurationGetFetched event,
    Emitter<UserConfigurationGetState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.getUserConfiguration();
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            data: data == null
                ? null
                : UserConfiguration(
                    profile: data.profile,
                    settings: _normalizeSettings(data.settings),
                  ),
          ),
        );
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

  UserSetting? _normalizeSettings(UserSetting? settings) {
    if (settings == null) return null;
    if (settings.display_language != null) return settings;
    return settings.copyWith(
      display_language: Platform.localeName.split('_').first,
    );
  }

  Future<void> _onReset(
    UserConfigurationGetReset event,
    Emitter<UserConfigurationGetState> emit,
  ) async {
    emit(
      state.copyWith(
        data: null,
        error: null,
        requestStatus: RequestStatus.success,
      ),
    );
  }

  void _onProfileUpdated(
    UserConfigurationGetProfileUpdated event,
    Emitter<UserConfigurationGetState> emit,
  ) {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.success,
        data: UserConfiguration(
          profile: event.profile,
          settings: _normalizeSettings(state.data?.settings),
        ),
      ),
    );
  }
}
