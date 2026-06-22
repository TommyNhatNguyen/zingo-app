import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/dtos/users/users_favorite_dialog_dto.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/user_dialog_favorite.dart';

class UserFavoriteDialogsService {
  Future<PaginatedApiResult<UserDialogFavorite>> getFavoriteDialogs(
    ListFavoriteDialogsPayload payload,
  ) async {
    final response = await dio.get(
      '/v1/favorite-dialogs/${payload.userId}',
      queryParameters: {'page': payload.page, 'limit': payload.limit},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    final meta = data['meta'] as Map<String, dynamic>;
    final success = response.data['success'] ?? false;
    final error = response.data['error'];

    if (!success || error != null) {
      throw Exception(error);
    }

    return PaginatedApiResult<UserDialogFavorite>(
      success: success,
      meta: PaginationMeta.fromJson(meta),
      data: items.map((e) => UserDialogFavorite.fromJson(e)).toList(),
    );
  }

  Future<bool> addFavorite(UsersFavoriteDialogDto payload) async {
    final response = await dio.post(
      '/v1/favorite-dialogs',
      data: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    return result.success;
  }

  Future<bool> removeFavorite(UsersFavoriteDialogDto payload) async {
    final response = await dio.delete(
      '/v1/favorite-dialogs',
      data: payload.toJson(),
    );
    final result = ApiResponse.fromJson(response.data);
    return result.success;
  }
}
