import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_event.dart';
import 'package:zingo/core/blocs/user/get-streak/user_streak_get_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/user_streak_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';

class UserStreakGetBloc extends Bloc<UserStreakGetEvent, UserStreakGetState> {
  final UserStreakRepository _repository;

  UserStreakGetBloc({UserStreakRepository? repository})
    : _repository =
          repository ??
          UserStreakRepository(
            apiClientService: ApiClientService(httpClient: dio),
          ),
      super(UserStreakGetState.initial()) {
    on<UserStreakGetFetched>(_onFetched);
    on<UserStreakGetReset>(_onReset);
  }

  Future<void> _onFetched(
    UserStreakGetFetched event,
    Emitter<UserStreakGetState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repository.getUserStreak(event.payload);
    switch (result) {
      case Ok(:final data):
        emit(
          state.copyWith(
            data: data,
            requestStatus: RequestStatus.success,
            error: null,
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

  Future<void> _onReset(
    UserStreakGetReset event,
    Emitter<UserStreakGetState> emit,
  ) async {
    emit(UserStreakGetState.initial());
  }
}
