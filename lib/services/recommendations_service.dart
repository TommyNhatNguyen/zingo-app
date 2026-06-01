import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/recommendations/recommendations_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/dialog.dart';

class RecommendationsService {
  Future<PaginatedApiResult<Dialog>> getRecommendations(
    RecommendationsPayload payload,
  ) async {
    try {
      final response = await dio.get(
        '/v1/recommendations',
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

      return PaginatedApiResult<Dialog>(
        success: success,
        meta: PaginationMeta.fromJson(meta),
        data: items.map((e) => Dialog.fromJson(e)).toList(),
        error: error,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
