import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/user_streak.dart';

class UserStreakService {
  Future<UserStreak?> getUserStreak(
    GetUserStreakPayload payload,
  ) async {
    final response = await dio.get(
      '/v1/streak',
      queryParameters: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      if (result.data == null) return null;
      return UserStreak.fromJson(result.data as Map<String, dynamic>);
    } else {
      throw Exception(result.error);
    }
  }
}
