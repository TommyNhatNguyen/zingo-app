import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/practice-sessions/complete_session_payload.dart';
import 'package:zingo/dtos/practice-sessions/create_session_payload.dart';
import 'package:zingo/dtos/practice-sessions/list_active_dialogs_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/completed_practice_session.dart';
import 'package:zingo/models/dialog.dart';
import 'package:zingo/models/practice_session.dart';

class PracticeSessionsService {
  Future<List<Dialog>?> getActiveDialogs(
    ListActiveDialogsPayload payload,
  ) async {
    try {
      final response = await dio.get(
        '/v1/practice-sessions/uncompleted/${payload.userId}',
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

  Future<PracticeSession?> startSession(CreateSessionPayload payload) async {
    try {
      final response = await dio.post(
        '/v1/practice-start',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return PracticeSession.fromJson(result.data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CompletedPracticeSession?> completeSession(
    CompleteSessionPayload payload,
  ) async {
    try {
      final response = await dio.post(
        '/v1/practice-complete',
        data: payload.toJson(),
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        return CompletedPracticeSession.fromJson(result.data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
