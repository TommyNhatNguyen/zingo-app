import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/practice-sessions/complete_session_payload.dart';
import 'package:zingo/domain/dtos/practice-sessions/create_session_payload.dart';
import 'package:zingo/domain/dtos/practice-sessions/list_active_dialogs_payload.dart';
import 'package:zingo/domain/models/completed_practice_session.dart';
import 'package:zingo/domain/models/dialog.dart';
import 'package:zingo/domain/models/practice_session.dart';

class PracticeSessionRepository {
  final ApiClientService _apiClientService;

  PracticeSessionRepository({required ApiClientService apiClientService})
      : _apiClientService = apiClientService;

  Future<Result<List<Dialog>?>> getActiveDialogs(
    ListActiveDialogsPayload payload,
  ) {
    return _apiClientService.getActiveDialogs(payload);
  }

  Future<Result<PracticeSession?>> startSession(
    CreateSessionPayload payload,
  ) {
    return _apiClientService.startSession(payload);
  }

  Future<Result<CompletedPracticeSession?>> completeSession(
    CompleteSessionPayload payload,
  ) {
    return _apiClientService.completeSession(payload);
  }
}
