import 'package:bloc/bloc.dart';
import 'package:zingo/core/blocs/user/get/users_event.dart';
import 'package:zingo/core/blocs/user/get/users_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/core/network/dio_http.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/user_repository.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/users/users_create_dto.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository _repository;

  UsersBloc({UserRepository? repository})
      : _repository = repository ??
            UserRepository(apiClientService: ApiClientService(httpClient: dio)),
        super(UsersState.initial()) {
    on<UsersRegister>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      final result = await _repository.registerUser(
        UsersCreateDto(
          email: event.email,
          username: event.username,
          password: event.password,
        ),
      );
      switch (result) {
        case Ok(:final data):
          emit(
            state.copyWith(requestStatus: RequestStatus.success, data: data),
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
    });
  }
}
