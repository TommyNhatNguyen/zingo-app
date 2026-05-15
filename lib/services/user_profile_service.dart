import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/user-profile/user_profile_create_dto.dart';
import 'package:zingo/dtos/user-profile/user_profile_update_dto.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/user_profile.dart';

class UserProfileService {
  Future<UserProfile?> onboarding(UserProfileCreateDto payload) async {
    final response = await dio.post(
      '/v1/user-profile/onboarding',
      data: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) {
        return null;
      }
      return UserProfile.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<UserProfile?> getById(String userId) async {
    final response = await dio.get('/v1/user-profile/$userId');
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) {
        return null;
      }
      return UserProfile.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }

  Future<UserProfile?> update(
    String userId,
    UserProfileUpdateDto payload,
  ) async {
    final response = await dio.put(
      '/v1/user-profile/$userId',
      data: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) {
        return null;
      }
      return UserProfile.fromJson(result.data!);
    } else {
      throw Exception(result.error);
    }
  }
}
