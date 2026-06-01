import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/practice-sessions/list_active_dialogs_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/dialog.dart';

class PracticeSessionsService {
  Future<List<Dialog>?> getActiveDialogs(
    ListActiveDialogsPayload payload,
  ) async {
    try {
      final response = await dio.get(
        '/v1/practice-sessions/active-dialogs/${payload.userId}',
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
