import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/services/auth_service.dart';
import 'package:zingo/services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();
  final _userService = UserService();

  AuthBloc() : super(AuthState.initial()) {
    on<AuthRestoreSession>(_onRestoreSession);
    on<AuthApplyBackendUser>(_onApplyBackendUser);

    on<AuthLoginWithEmailAndPassword>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final user = await _authService.loginWithEmailAndPassword(
          event.payload,
        );
        if (user != null) {
          await _emitAfterFirebaseUser(user, emit);
        }
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
        final user = await _authService.loginWithGoogle();
        if (user != null) {
          await _emitAfterFirebaseUser(user, emit);
        }
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

    Future.microtask(() => add(const AuthRestoreSession()));
  }

  Future<void> _onRestoreSession(
    AuthRestoreSession event,
    Emitter<AuthState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(AuthState.initial());
      return;
    }
    try {
      await _emitAfterFirebaseUser(user, emit);
    } catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onApplyBackendUser(
    AuthApplyBackendUser event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.success,
        data: event.data,
        user: FirebaseAuth.instance.currentUser ?? state.user,
      ),
    );
  }

  Future<void> _emitAfterFirebaseUser(
    User user,
    Emitter<AuthState> emit,
  ) async {
    final userData = await _userService.getUserByUid(user.uid);
    if (userData != null) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          data: userData,
          user: user,
        ),
      );
    } else {
      emit(
        state.copyWith(requestStatus: RequestStatus.success, user: user),
      );
    }
  }
}
