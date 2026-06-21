import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/recommendations/recommendations_payload.dart';
import 'package:zingo/models/journey.dart';

class RecommendationsService {
  Future<JourneyResponse?> getRecommendations(
    RecommendationsPayload payload,
  ) async {
    try {
      final response = await dio.get(
        '/v1/user-info/recommendations',
        queryParameters: payload.toJson(),
      );

      final success = response.data['success'] ?? false;
      final error = response.data['error'];

      if (!success || error != null) {
        throw Exception(error);
      }

      final data = response.data['data'];
      if (data == null) return null;

      return JourneyResponse.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(e);
    }
  }
}
