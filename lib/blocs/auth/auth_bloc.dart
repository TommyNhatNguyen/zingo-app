import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();
  AuthBloc() : super(AuthState.initial()) {
    on<AuthLoginWithEmailAndPassword>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final result = await _authService.loginWithEmailAndPassword(
          event.payload,
        );
        emit(
          state.copyWith(requestStatus: RequestStatus.success, data: result),
        );
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(requestStatus: RequestStatus.error, error: e.message),
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

    on<AuthLoginWithGoogle>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final result = await _authService.loginWithGoogle();
        emit(
          state.copyWith(requestStatus: RequestStatus.success, data: result),
        );
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(requestStatus: RequestStatus.error, error: e.message),
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
