import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zingo/blocs/user/get/users_event.dart';
import 'package:zingo/blocs/user/get/users_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/users/users_create_dto.dart';
import 'package:zingo/services/user_service.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final _userService = UserService();
  UsersBloc() : super(UsersState.initial()) {
    on<UsersRegister>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));

        final result = await _userService.registerUser(
          UsersCreateDto(
            email: event.email,
            username: event.username,
            password: event.password,
          ),
        );

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
