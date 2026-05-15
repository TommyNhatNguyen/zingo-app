import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/user-profile-topics/user_topics_set_dto.dart';

/// Talks to `/v1/user-profile-topics/*`.
///
/// The list endpoints return `{ success, data: [...] }` where `data` is an
/// array, so we don't go through [ApiResponse.fromJson] (which assumes
/// `data` is a Map). Each row can be one of:
///   - a bare `String` code,
///   - a full `topics` row joined in (uses `normalize_name`),
///   - a `user_topic_preferences` junction row (uses `topic_normalize_name`).
class UserTopicPreferencesService {
  Future<List<String>> getByUserId(String userId) async {
    final response = await dio.get('/v1/user-profile-topics/$userId');
    return _parseTopicCodes(response.data);
  }

  Future<List<String>> setTopics(
    String userId,
    List<String> topicNormalizeNames,
  ) async {
    final response = await dio.put(
      '/v1/user-profile-topics/$userId',
      data: UserTopicsSetDto(
        topic_normalize_names: topicNormalizeNames,
      ).toJson(),
    );
    return _parseTopicCodes(response.data);
  }

  List<String> _parseTopicCodes(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      throw Exception('Unexpected topics response: $raw');
    }
    final success = raw['success'] == true;
    if (!success) {
      throw Exception(raw['error']?.toString() ?? 'Failed to load topics');
    }
    final data = raw['data'];
    if (data == null) return const [];
    if (data is! List) {
      throw Exception('Topics data is not a list: $data');
    }
    return data
        .map<String>((e) {
          if (e is String) return e;
          if (e is Map) {
            final code =
                e['topic_normalize_name'] ?? e['normalize_name'] ?? e['code'];
            if (code is String) return code;
          }
          throw Exception('Unexpected topic entry: $e');
        })
        .toList(growable: false);
  }
}
