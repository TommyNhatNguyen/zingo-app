import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/dialog/dialog_list_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/dialog.dart';

class DialogService {
  Future<PaginatedApiResult<Dialog>> getDialogs(
    DialogListPayload payload,
  ) async {
    try {
      final response = await dio.get(
        '/v1/dialogs',
        queryParameters: payload.toJson(),
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;
      final meta = data['meta'] as Map<String, dynamic>;
      final success = response.data['success'] ?? false;
      final error = response.data['error'];

      if (!success || error != null) {
        throw Exception(error);
      }

      final result = PaginatedApiResult<Dialog>(
        success: success,
        meta: PaginationMeta.fromJson(meta),
        data: items.map((e) => Dialog.fromJson(e)).toList(),
        error: error,
      );

      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
