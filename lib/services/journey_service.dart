import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/journey/journey_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/journey.dart';

typedef JourneyResult = ({
  List<JourneyChapter> chapters,
  PaginationMeta meta,
});

class JourneyService {
  Future<JourneyResult> getJourney(JourneyPayload payload) async {
    try {
      final response = await dio.get(
        '/v1/user-info/journey',
        queryParameters: payload.toJson(),
      );

      final success = response.data['success'] ?? false;
      final error = response.data['error'];

      if (!success || error != null) {
        throw Exception(error);
      }

      final data = response.data['data'];
      if (data == null) {
        return (chapters: <JourneyChapter>[], meta: PaginationMeta());
      }

      final chapters = (data['chapters'] as List<dynamic>)
          .map((e) => JourneyChapter.fromJson(e as Map<String, dynamic>))
          .toList();

      final meta = PaginationMeta.fromJson(data['meta'] as Map<String, dynamic>);

      return (chapters: chapters, meta: meta);
    } catch (e) {
      throw Exception(e);
    }
  }
}
