import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zingo/blocs/user/get-setting/user_settings_get_event.dart';
import 'package:zingo/blocs/user/get-setting/user_settings_get_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/user_service.dart';

class UserSettingsGetBloc
    extends Bloc<UserSettingsEvent, UserSettingsGetState> {
  final UserService _userService = UserService();

  UserSettingsGetBloc() : super(UserSettingsGetState.initial()) {
    on<UserSettingsGetFetched>(_onFetched);
  }

  Future<void> _onFetched(
    UserSettingsGetFetched event,
    Emitter<UserSettingsGetState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final data = await _userService.getSetting(event.userId);
      final normalized = data?.display_language == null
          ? data?.copyWith(
              display_language: Platform.localeName.split('_').first,
            )
          : data;
      emit(
        state.copyWith(requestStatus: RequestStatus.success, data: normalized),
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
}
