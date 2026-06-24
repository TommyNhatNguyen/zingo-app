import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/journey/journey_payload.dart';
import 'package:zingo/domain/dtos/recommendations/recommendations_payload.dart';
import 'package:zingo/domain/models/journey.dart';

typedef JourneyResult = ({List<JourneyChapter> chapters, PaginationMeta meta});

class RecommendationRepository {
  final ApiClientService _apiClientService;

  RecommendationRepository({required ApiClientService apiClientService})
      : _apiClientService = apiClientService;

  Future<Result<JourneyResponse?>> getRecommendations(
    RecommendationsPayload payload,
  ) {
    return _apiClientService.getRecommendations(payload);
  }

  Future<Result<JourneyResult>> getJourney(JourneyPayload payload) {
    return _apiClientService.getJourney(payload);
  }
}
