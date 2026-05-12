import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/users/users_create_dto.dart';
import 'package:zingo/interfaces/api_response.dart';
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
}
