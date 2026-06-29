import 'package:bloc/bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:zingo/core/blocs/user/create-profile/user_profile_create_event.dart';
import 'package:zingo/core/blocs/user/create-profile/user_profile_create_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/user_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class UserProfileCreateBloc
    extends Bloc<UserProfileCreateEvent, UserProfileCreateState> {
  final UserRepository _repository;

  UserProfileCreateBloc({UserRepository? repository})
    : _repository =
          repository ??
          UserRepository(apiClientService: ApiClientService(httpClient: dio)),
      super(UserProfileCreateState.initial()) {
    on<UserProfileCreateTrigger>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      final result = await _repository.onboarding(event.payload);
      switch (result) {
        case Ok(:final data):
          debugPrint('error: ${data}');
          emit(
            state.copyWith(requestStatus: RequestStatus.success, data: data),
          );
        case Error(:final error):
          debugPrint('error: ${error}');
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: error.toString(),
            ),
          );
        case ErrorAPI(:final error):
          debugPrint('error: ${error.error}');
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              error: error.error.detail,
            ),
          );
      }
    });
  }
}
