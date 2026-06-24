import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/user-profile/user_profile_create_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_from_anonymous_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_from_login_google_dto.dart';
import 'package:zingo/domain/dtos/users/users_update_dto.dart';
import 'package:zingo/domain/models/user_profile.dart';
import 'package:zingo/domain/models/users.dart';

class UserRepository {
  final ApiClientService _apiClientService;

  const UserRepository({required ApiClientService apiClientService})
      : _apiClientService = apiClientService;

  Future<Result<Users?>> getUserByUid() {
    return _apiClientService.getUserByUid();
  }

  Future<Result<Users?>> registerUser(UsersCreateDto payload) {
    return _apiClientService.registerUser(payload);
  }

  Future<Result<Users?>> registerWithGoogle(
    UsersCreateFromLoginGoogleDto payload,
  ) {
    return _apiClientService.registerWithGoogle(payload);
  }

  Future<Result<Users?>> registerWithAnonymous(
    UsersCreateFromAnonymousDto payload,
  ) {
    return _apiClientService.registerWithAnonymous(payload);
  }

  Future<Result<UserProfile?>> onboarding(UserProfileCreateDto payload) {
    return _apiClientService.onboarding(payload);
  }

  Future<Result<Users?>> updateUser(String userId, UsersUpdateDto payload) {
    return _apiClientService.updateUser(userId, payload);
  }
}
