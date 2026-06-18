import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zingo/blocs/user/get-streak/user_streak_get_event.dart';
import 'package:zingo/blocs/user/get-streak/user_streak_get_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/user_streak_service.dart';

class UserStreakGetBloc extends Bloc<UserStreakGetEvent, UserStreakGetState> {
  final UserStreakService _userStreakService;

  UserStreakGetBloc({UserStreakService? userStreakService})
    : _userStreakService = userStreakService ?? UserStreakService(),
      super(UserStreakGetState.initial()) {
    on<UserStreakGetFetched>(_onFetched);
  }

  Future<void> _onFetched(
    UserStreakGetFetched event,
    Emitter<UserStreakGetState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      final streak = await _userStreakService.getUserStreak(
        event.userId,
        event.payload,
      );
      emit(
        state.copyWith(
          data: streak,
          requestStatus: RequestStatus.success,
          error: null,
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
}
