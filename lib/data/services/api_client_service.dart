import 'package:dio/dio.dart';
import 'package:zingo/domain/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/domain/dtos/dialog/dialog_detail_payload.dart';
import 'package:zingo/domain/dtos/dialog/dialog_list_payload.dart';
import 'package:zingo/domain/dtos/dialog/recent_dialogs_payload.dart';
import 'package:zingo/domain/dtos/journey/journey_payload.dart';
import 'package:zingo/domain/dtos/practice-sessions/complete_session_payload.dart';
import 'package:zingo/domain/dtos/practice-sessions/create_session_payload.dart';
import 'package:zingo/domain/dtos/practice-sessions/list_active_dialogs_payload.dart';
import 'package:zingo/domain/dtos/recommendations/recommendations_payload.dart';
import 'package:zingo/domain/dtos/user-configuration/user_configuration_update_dto.dart';
import 'package:zingo/domain/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/domain/dtos/user-profile/user_profile_create_dto.dart';
import 'package:zingo/domain/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/domain/dtos/users/users_create_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_from_anonymous_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_from_login_google_dto.dart';
import 'package:zingo/domain/dtos/users/users_favorite_dialog_dto.dart';
import 'package:zingo/domain/dtos/users/users_update_dto.dart';
import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/domain/models/completed_practice_session.dart';
import 'package:zingo/domain/models/dialog.dart';
import 'package:zingo/domain/models/dialog_turn.dart';
import 'package:zingo/domain/models/journey.dart';
import 'package:zingo/domain/models/practice_session.dart';
import 'package:zingo/domain/models/user_configuration.dart';
import 'package:zingo/domain/models/user_dialog_favorite.dart';
import 'package:zingo/domain/models/user_profile.dart';
import 'package:zingo/domain/models/user_streak.dart';
import 'package:zingo/domain/models/users.dart';
import 'package:zingo/data/model/api_error.dart';
import 'package:zingo/data/model/result.dart';

typedef JourneyResult = ({List<JourneyChapter> chapters, PaginationMeta meta});

class ApiClientService {
  final Dio _httpClient;

  ApiClientService({required Dio httpClient}) : _httpClient = httpClient;

  Result<T> _dioErrorResult<T>(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      try {
        return Result.errorAPI(ApiErrorResponse.fromJson(data));
      } catch (_) {}
    }

    return Result.errorAPI(
      ApiErrorResponse(
        error: BaseError(
          code: 'REQUEST_FAILED',
          type: e.type.name,
          detail: e.message ?? 'Request failed',
          title: 'Request failed',
          statusCode: e.response?.statusCode ?? 0,
          timeStamp: null,
        ),
      ),
    );
  }

  Future<Result<dynamic>> test() async {
    try {
      final response = await _httpClient.get("/v1/test");
      print("Response: ${response.data}");
      return Result.ok(response.data);
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      print("Error: $e");
      return Result.error(e);
    }
  }

  // --- User ---

  Future<Result<Users>> getUserByUid() async {
    try {
      final response = await _httpClient.get('/v1/user');
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(Users.fromJson(result.data));
      } else {
        return Result.error(Exception(result.error));
      }
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Users?>> registerUser(UsersCreateDto payload) async {
    try {
      final response = await _httpClient.post(
        '/v1/register',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null ? null : Users.fromJson(result.data!),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Users?>> registerWithGoogle(
    UsersCreateFromLoginGoogleDto payload,
  ) async {
    try {
      final response = await _httpClient.post(
        '/v1/auth-google',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null ? null : Users.fromJson(result.data!),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Users?>> registerWithAnonymous(
    UsersCreateFromAnonymousDto payload,
  ) async {
    try {
      final response = await _httpClient.post(
        '/v1/auth-anonymous',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null ? null : Users.fromJson(result.data!),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Users?>> updateUser(
    String userId,
    UsersUpdateDto payload,
  ) async {
    try {
      final response = await _httpClient.put(
        '/v1/user/$userId',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null ? null : Users.fromJson(result.data!),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<UserProfile?>> onboarding(UserProfileCreateDto payload) async {
    try {
      final response = await _httpClient.post(
        '/v1/onboarding',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null ? null : UserProfile.fromJson(result.data!),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<UserConfiguration?>> getUserConfiguration() async {
    try {
      final response = await _httpClient.get('/v1/user-configuration');
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null
              ? null
              : UserConfiguration.fromJson(result.data as Map<String, dynamic>),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<UserConfiguration?>> updateUserConfiguration(
    UserConfigurationUpdateDto payload,
  ) async {
    try {
      final response = await _httpClient.put(
        '/v1/user-configuration',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null
              ? null
              : UserConfiguration.fromJson(result.data as Map<String, dynamic>),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // --- User Streak ---

  Future<Result<UserStreak?>> getUserStreak(
    GetUserStreakPayload payload,
  ) async {
    try {
      final response = await _httpClient.get(
        '/v1/streak',
        queryParameters: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null
              ? null
              : UserStreak.fromJson(result.data as Map<String, dynamic>),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // --- Dialogs ---

  Future<Result<PaginatedApiResult<Dialog>>> getDialogs(
    DialogListPayload payload,
  ) async {
    try {
      final response = await _httpClient.get(
        '/v1/dialogs',
        queryParameters: payload.toJson(),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;
      final meta = data['meta'] as Map<String, dynamic>;
      final success = response.data['success'] ?? false;
      final error = response.data['error'];
      if (!success || error != null) return Result.error(Exception(error));
      return Result.ok(
        PaginatedApiResult<Dialog>(
          success: success,
          meta: PaginationMeta.fromJson(meta),
          data: items.map((e) => Dialog.fromJson(e)).toList(),
          error: error,
        ),
      );
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<PaginatedApiResult<Dialog>>> getRecentDialogs(
    String userId,
    RecentDialogsPayload payload,
  ) async {
    try {
      final response = await _httpClient.get(
        '/v1/recent-practice-dialogs/$userId',
        queryParameters: payload.toJson(),
      );
      final success = response.data['success'] ?? false;
      final error = response.data['error'];
      if (!success || error != null) return Result.error(Exception(error));
      final data = response.data['data'] as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;
      final meta = data['meta'] as Map<String, dynamic>;
      return Result.ok(
        PaginatedApiResult<Dialog>(
          success: success,
          meta: PaginationMeta.fromJson(meta),
          data: items.map((e) => Dialog.fromJson(e)).toList(),
          error: error,
        ),
      );
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Dialog?>> getDialogDetail(DialogDetailPayload payload) async {
    try {
      final response = await _httpClient.get('/v1/dialogs/${payload.id}');
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null ? null : Dialog.fromJson(result.data!),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // --- Dialog Turns ---

  Future<Result<List<DialogTurn>?>> getDialogTurnsByDialogId(
    DialogTurnsByDialogIdPayload payload,
  ) async {
    try {
      final response = await _httpClient.get(
        '/v1/dialogs/${payload.dialogId}/turns',
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        final data = result.data as List<dynamic>?;
        return Result.ok(
          data?.map((item) => DialogTurn.fromJson(item)).toList(),
        );
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // --- Recommendations ---

  Future<Result<JourneyResponse?>> getRecommendations(
    RecommendationsPayload payload,
  ) async {
    try {
      final response = await _httpClient.get(
        '/v1/recommend-dialogs/${payload.user_id}',
        queryParameters: payload.toJson(),
      );
      final success = response.data['success'] ?? false;
      final error = response.data['error'];
      if (!success || error != null) return Result.error(Exception(error));
      final data = response.data['data'];
      return Result.ok(
        data == null
            ? null
            : JourneyResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<JourneyResult>> getJourney(JourneyPayload payload) async {
    try {
      final response = await _httpClient.get(
        '/v1/recommend-journey/${payload.user_id}',
        queryParameters: payload.toJson(),
      );
      final success = response.data['success'] ?? false;
      final error = response.data['error'];
      if (!success || error != null) return Result.error(Exception(error));
      final data = response.data['data'];
      if (data == null) {
        return Result.ok((
          chapters: <JourneyChapter>[],
          meta: PaginationMeta(),
        ));
      }
      final chapters = (data['chapters'] as List<dynamic>)
          .map((e) => JourneyChapter.fromJson(e as Map<String, dynamic>))
          .toList();
      final meta = PaginationMeta.fromJson(
        data['meta'] as Map<String, dynamic>,
      );
      return Result.ok((chapters: chapters, meta: meta));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // --- User Favorite Dialogs ---

  Future<Result<PaginatedApiResult<UserDialogFavorite>>> getFavoriteDialogs(
    ListFavoriteDialogsPayload payload,
  ) async {
    try {
      final response = await _httpClient.get(
        '/v1/favorite-dialogs/${payload.userId}',
        queryParameters: {'page': payload.page, 'limit': payload.limit},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;
      final meta = data['meta'] as Map<String, dynamic>;
      final success = response.data['success'] ?? false;
      final error = response.data['error'];
      if (!success || error != null) return Result.error(Exception(error));
      return Result.ok(
        PaginatedApiResult<UserDialogFavorite>(
          success: success,
          meta: PaginationMeta.fromJson(meta),
          data: items.map((e) => UserDialogFavorite.fromJson(e)).toList(),
        ),
      );
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> addFavorite(UsersFavoriteDialogDto payload) async {
    try {
      final response = await _httpClient.post(
        '/v1/favorite-dialogs',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      return Result.ok(result.success);
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> removeFavorite(UsersFavoriteDialogDto payload) async {
    try {
      final response = await _httpClient.delete(
        '/v1/favorite-dialogs',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      return Result.ok(result.success);
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // --- Practice Sessions ---

  Future<Result<List<Dialog>?>> getActiveDialogs(
    ListActiveDialogsPayload payload,
  ) async {
    try {
      final response = await _httpClient.get(
        '/v1/practice-sessions/uncompleted/${payload.userId}',
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        final data = result.data as List<dynamic>?;
        return Result.ok(data?.map((item) => Dialog.fromJson(item)).toList());
      }
      return Result.error(Exception(result.error));
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<PracticeSession?>> startSession(
    CreateSessionPayload payload,
  ) async {
    try {
      final response = await _httpClient.post(
        '/v1/practice-start',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null ? null : PracticeSession.fromJson(result.data),
        );
      }
      return Result.ok(null);
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<CompletedPracticeSession?>> completeSession(
    CompleteSessionPayload payload,
  ) async {
    try {
      final response = await _httpClient.post(
        '/v1/practice-complete',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return Result.ok(
          result.data == null
              ? null
              : CompletedPracticeSession.fromJson(result.data),
        );
      }
      return Result.ok(null);
    } on DioException catch (e) {
      return _dioErrorResult(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
