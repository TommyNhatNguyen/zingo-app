import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/core/blocs/auth/auth_event.dart';
import 'package:zingo/core/blocs/auth/auth_state.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/repositories/auth_repository.dart';
import 'package:zingo/domain/dtos/users/users_create_from_anonymous_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_from_login_google_dto.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final Stream<User?> _authStateStream = FirebaseAuth.instance
      .authStateChanges();

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthState.initial()) {
    _authStateStream.listen((user) {
      final isAuthenticated = state.user != null;
      if (isAuthenticated && user == null) {
        add(AuthLoggedOut());
      } else if (!isAuthenticated && user != null) {
        add(AuthStateChanged(user: user));
      }
    });

    on<AuthLoggedOut>((event, emit) async {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      // Already logged out, do nothing
      if (FirebaseAuth.instance.currentUser == null) {
        emit(AuthState.loggedOut());
        return;
      }
      // Log out the user
      try {
        await _authRepository.logout();
      } catch (e) {
        emit(
          state.copyWith(
            user: null,
            data: null,
            requestStatus: RequestStatus.error,
            error: e.toString(),
          ),
        );
      }
    });

    on<AuthStateChanged>((event, emit) async {
      emit(
        state.copyWith(user: event.user, requestStatus: RequestStatus.loading),
      );
      final result = await _authRepository.getUserByUid();
      switch (result) {
        case Ok(:final data):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.success,
              data: data,
              user: event.user,
            ),
          );
        case Error(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              user: event.user,
              data: null,
              error: error.toString(),
            ),
          );
        case ErrorAPI(:final error):
          emit(
            state.copyWith(
              requestStatus: RequestStatus.error,
              user: event.user,
              data: null,
              error: error.error.title,
            ),
          );
      }
    });

    on<AuthLoginWithEmailAndPassword>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final user = await _authRepository.loginWithEmailAndPassword(
          event.payload,
        );
        if (user != null) {
          final result = await _authRepository.getUserByUid();
          switch (result) {
            case Ok(:final data):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.success,
                  data: data,
                  user: user,
                ),
              );
            case Error(:final error):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.success,
                  data: null,
                  user: user,
                  error: error.toString(),
                ),
              );
            case ErrorAPI(:final error):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.success,
                  data: null,
                  user: user,
                  error: error.error.title,
                ),
              );
          }
        }
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(requestStatus: RequestStatus.error, error: e.message),
        );
      } on Exception catch (e) {
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
        final user = await _authRepository.loginWithGoogle();
        if (user != null) {
          final result = await _authRepository.registerWithGoogle(
            UsersCreateFromLoginGoogleDto(
              email: user.email ?? '',
              username: user.displayName ?? '',
              user_uid: user.uid,
            ),
          );
          switch (result) {
            case Ok(:final data):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.success,
                  user: user,
                  data: data,
                ),
              );
            case Error(:final error):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.error,
                  error: error.toString(),
                  user: null,
                  data: null,
                ),
              );
            case ErrorAPI(:final error):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.error,
                  error: error.error.title,
                  data: null,
                  user: null,
                ),
              );
          }
        }
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.message,
            user: null,
            data: null,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.toString(),
            user: null,
            data: null,
          ),
        );
      }
    });

    on<AuthLoginWithAnonymous>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final user = await _authRepository.loginWithAnonymous();
        if (user != null) {
          final result = await _authRepository.registerWithAnonymous(
            UsersCreateFromAnonymousDto(user_uid: user.uid),
          );
          switch (result) {
            case Ok(:final data):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.success,
                  user: user,
                  data: data,
                ),
              );
            case Error(:final error):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.error,
                  error: error.toString(),
                  user: null,
                  data: null,
                ),
              );
            case ErrorAPI(:final error):
              emit(
                state.copyWith(
                  requestStatus: RequestStatus.error,
                  error: error.error.title,
                  user: null,
                  data: null,
                ),
              );
          }
        }
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.message,
            user: null,
            data: null,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            error: e.toString(),
            user: null,
            data: null,
          ),
        );
      }
    });
  }
}
