import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/dialog.dart';

class UserFavoriteDialogsService {
  Future<List<Dialog>?> getFavoriteDialogs(
    ListFavoriteDialogsPayload payload,
  ) async {
    try {
      final response = await dio.get(
        '/v1/user-favorite-dialogs/${payload.userId}',
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        final data = result.data as List<dynamic>?;
        if (data == null) {
          return null;
        }
        return data.map((item) => Dialog.fromJson(item)).toList();
      } else {
        throw Exception(result.error);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
