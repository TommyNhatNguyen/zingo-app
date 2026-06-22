import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/user-configuration/user_configuration_update_dto.dart';
import 'package:zingo/dtos/user-profile/user_profile_create_dto.dart';
import 'package:zingo/dtos/users/users_create_dto.dart';
import 'package:zingo/dtos/users/users_create_from_anonymous_dto.dart';
import 'package:zingo/dtos/users/users_create_from_login_google_dto.dart';
import 'package:zingo/dtos/users/users_update_dto.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/user_configuration.dart';
import 'package:zingo/models/user_profile.dart';
import 'package:zingo/models/users.dart';

class UserService {
  Future<Users?> registerUser(UsersCreateDto payload) async {
    final response = await dio.post('/v1/register', data: payload.toJson());
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) {
        return null;
      }
      return Users.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<Users?> registerWithGoogle(
    UsersCreateFromLoginGoogleDto payload,
  ) async {
    final response = await dio.post('/v1/auth-google', data: payload.toJson());
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) {
        return null;
      }
      return Users.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<Users?> registerWithAnonymous(
    UsersCreateFromAnonymousDto payload,
  ) async {
    final response = await dio.post(
      '/v1/auth-anonymous',
      data: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) {
        return null;
      }
      return Users.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<Users?> getUserByUid() async {
    final response = await dio.get('/v1/user');
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) {
        return null;
      }
      return Users.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<Users?> update(String userId, UsersUpdateDto payload) async {
    final response = await dio.put('/v1/user/$userId', data: payload.toJson());
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) return null;
      return Users.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<UserProfile?> onboarding(UserProfileCreateDto payload) async {
    final response = await dio.post('/v1/onboarding', data: payload.toJson());
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) return null;
      return UserProfile.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<UserConfiguration?> getUserConfiguration() async {
    final response = await dio.get('/v1/user-configuration');
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) return null;
      return UserConfiguration.fromJson(result.data as Map<String, dynamic>);
    } else {
      throw Exception(result.error);
    }
  }

  Future<UserConfiguration?> updateUserConfiguration(
    UserConfigurationUpdateDto payload,
  ) async {
    final response = await dio.put(
      '/v1/user-configuration',
      data: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) return null;
      return UserConfiguration.fromJson(result.data as Map<String, dynamic>);
    } else {
      throw Exception(result.error);
    }
  }
}
