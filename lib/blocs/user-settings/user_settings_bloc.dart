import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/blocs/user-settings/user_settings_event.dart';
import 'package:zingo/blocs/user-settings/user_settings_state.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/dtos/users/users_update_dto.dart';
import 'package:zingo/models/user_profile.dart';
import 'package:zingo/models/users.dart';
import 'package:zingo/services/user_profile_service.dart';
import 'package:zingo/services/user_service.dart';
import 'package:zingo/services/user_topic_preferences_service.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  final UserService _userService;
  final UserProfileService _profileService;
  final UserTopicPreferencesService _topicService;

  UserSettingsBloc({
    UserService? userService,
    UserProfileService? profileService,
    UserTopicPreferencesService? topicService,
    Users? seedUser,
  }) : _userService = userService ?? UserService(),
       _profileService = profileService ?? UserProfileService(),
       _topicService = topicService ?? UserTopicPreferencesService(),
       super(
         seedUser != null
             ? UserSettingsState(user: seedUser)
             : UserSettingsState.initial(),
       ) {
    on<UserSettingsLoaded>(_onLoaded);
    on<UserSettingsSaved>(_onSaved);
    on<UserSettingsLoggedOut>(_onLoggedOut);
  }

  Future<void> _onLoaded(
    UserSettingsLoaded event,
    Emitter<UserSettingsState> emit,
  ) async {
    emit(state.copyWith(loadStatus: RequestStatus.loading, clearError: true));
    try {
      final results = await Future.wait<Object?>([
        _profileService.getById(event.userId),
        _topicService.getByUserId(event.userId),
      ]);
      final profile = results[0] as UserProfile?;
      final codes = (results[1] as List<String>?) ?? const <String>[];
      emit(
        state.copyWith(
          loadStatus: RequestStatus.success,
          profile: profile,
          topicCodes: codes,
          clearError: true,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          loadStatus: RequestStatus.error,
          error: e.response?.data?['message']?.toString() ?? e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(loadStatus: RequestStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onSaved(
    UserSettingsSaved event,
    Emitter<UserSettingsState> emit,
  ) async {
    emit(state.copyWith(saveStatus: RequestStatus.loading, clearError: true));
    try {
      final futures = <Future<Object?>>[
        _profileService.update(event.userId, event.profile),
      ];
      if (event.cefrLevel != null) {
        futures.add(
          _userService.update(
            event.userId,
            UsersUpdateDto(cefr_level: event.cefrLevel),
          ),
        );
      }
      if (event.topicCodes != null) {
        futures.add(_topicService.setTopics(event.userId, event.topicCodes!));
      }

      final results = await Future.wait(futures);

      var idx = 0;
      final updatedProfile = results[idx++] as UserProfile?;
      final updatedUser = event.cefrLevel != null
          ? results[idx++] as Users?
          : null;
      final updatedTopics = event.topicCodes != null
          ? results[idx++] as List<String>?
          : null;

      emit(
        state.copyWith(
          saveStatus: RequestStatus.success,
          profile: updatedProfile ?? state.profile,
          user: updatedUser ?? state.user,
          topicCodes: updatedTopics ?? state.topicCodes,
          clearError: true,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          saveStatus: RequestStatus.error,
          error: e.response?.data?['message']?.toString() ?? e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(saveStatus: RequestStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onLoggedOut(
    UserSettingsLoggedOut event,
    Emitter<UserSettingsState> emit,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Sign-out errors are non-fatal here; redirect will still send to /login.
    }
  }
}
