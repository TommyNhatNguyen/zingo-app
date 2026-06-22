import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/blocs/auth/auth_event.dart';
import 'package:zingo/blocs/auth/auth_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/users/users_create_from_anonymous_dto.dart';
import 'package:zingo/dtos/users/users_create_from_login_google_dto.dart';
import 'package:zingo/services/auth_service.dart';
import 'package:zingo/services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();
  final _userService = UserService();
  final Stream<User?> _authStateStream = FirebaseAuth.instance
      .authStateChanges();

  AuthBloc() : super(AuthState.initial()) {
    _authStateStream.listen((user) {
      if (user != null) {
        add(AuthStateChanged(user: user));
      }
    });

    on<AuthLoggedOut>((event, emit) async {
      // Already logged out, do nothing
      if (FirebaseAuth.instance.currentUser == null) {
        emit(AuthState.loggedOut());
        return;
      }
      // Log out the user
      try {
        await FirebaseAuth.instance.signOut();
        emit(AuthState.loggedOut());
      } catch (e) {
        emit(
          state.copyWith(
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
      try {
        final userData = await _userService.getUserByUid();
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            data: userData,
            user: event.user,
          ),
        );
      } catch (e) {
        // Keep user set so the router doesn't kick authenticated users to /welcome.
        emit(
          state.copyWith(
            requestStatus: RequestStatus.error,
            user: event.user,
            error: e.toString(),
          ),
        );
      }
    });

    on<AuthLoginWithEmailAndPassword>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final user = await _authService.loginWithEmailAndPassword(
          event.payload,
        );
        if (user != null) {
          final userData = await _userService.getUserByUid();
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
          final newUserData = await _userService.registerWithGoogle(
            UsersCreateFromLoginGoogleDto(
              email: user.email ?? '',
              username: user.displayName ?? '',
              user_uid: user.uid,
            ),
          );
          emit(
            state.copyWith(
              requestStatus: RequestStatus.success,
              user: user,
              data: newUserData,
            ),
          );
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

    on<AuthLoginWithAnonymous>((event, emit) async {
      try {
        emit(state.copyWith(requestStatus: RequestStatus.loading));
        final user = await _authService.loginWithAnonymous();
        if (user != null) {
          final newUserData = await _userService.registerWithAnonymous(
            UsersCreateFromAnonymousDto(user_uid: user.uid),
          );
          emit(
            state.copyWith(
              requestStatus: RequestStatus.success,
              user: user,
              data: newUserData,
            ),
          );
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
  }
}
