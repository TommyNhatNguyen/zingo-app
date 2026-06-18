import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_event.dart';
import 'package:zingo/blocs/user/get-configuration/user_configuration_get_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/user_configuration.dart';
import 'package:zingo/models/user_setting.dart';
import 'package:zingo/services/user_service.dart';

class UserConfigurationGetBloc
    extends Bloc<UserConfigurationGetEvent, UserConfigurationGetState> {
  final _service = UserService();

  UserConfigurationGetBloc() : super(UserConfigurationGetState.initial()) {
    on<UserConfigurationGetFetched>(_onFetched);
  }

  Future<void> _onFetched(
    UserConfigurationGetFetched event,
    Emitter<UserConfigurationGetState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final config = await _service.getUserConfiguration(event.userId);
      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          data: config == null
              ? null
              : UserConfiguration(
                  profile: config.profile,
                  settings: _normalizeSettings(config.settings),
                ),
        ),
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
        state.copyWith(requestStatus: RequestStatus.error, error: e.toString()),
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
}
