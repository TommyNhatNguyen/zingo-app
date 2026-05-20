import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/users/users_favorite_dialog_dto.dart';
import 'package:zingo/interfaces/api_response.dart';

class UserFavoriteDialogService {
  Future<bool> addFavorite(UsersFavoriteDialogDto payload) async {
    final response = await dio.post(
      '/v1/users/favorite-dialog',
      data: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    if (result.success) {
      return true;
    } else {
      throw Exception(result.error);
    }
  }

  Future<void> removeFavorite(UsersFavoriteDialogDto payload) async {
    final response = await dio.delete(
      '/v1/users/favorite-dialog/${payload.dialog_id}',
      queryParameters: {'user_id': payload.user_id},
    );
    final result = ApiResponse.fromJson(response.data);
    if (!result.success) throw Exception(result.error);
  }
}
