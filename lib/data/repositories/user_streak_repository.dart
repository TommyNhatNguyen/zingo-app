import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/user-streak/get_user_streak_payload.dart';
import 'package:zingo/domain/models/user_streak.dart';

class UserStreakRepository {
  final ApiClientService _apiClientService;

  UserStreakRepository({required ApiClientService apiClientService})
      : _apiClientService = apiClientService;

  Future<Result<UserStreak?>> getUserStreak(GetUserStreakPayload payload) {
    return _apiClientService.getUserStreak(payload);
  }
}
