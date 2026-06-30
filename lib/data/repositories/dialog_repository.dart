import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/dialog/dialog_detail_payload.dart';
import 'package:zingo/domain/dtos/dialog/dialog_list_payload.dart';
import 'package:zingo/domain/dtos/dialog/popular_dialogs_payload.dart';
import 'package:zingo/domain/dtos/dialog/recent_dialogs_payload.dart';
import 'package:zingo/domain/models/dialog.dart';

class DialogRepository {
  final ApiClientService _apiClientService;

  DialogRepository({required ApiClientService apiClientService})
    : _apiClientService = apiClientService;

  Future<Result<PaginatedApiResult<Dialog>>> getPopularDialogs(
    PopularDialogsPayload payload,
  ) {
    return _apiClientService.getPopularDialogs(payload);
  }

  Future<Result<PaginatedApiResult<Dialog>>> getDialogs(
    DialogListPayload payload,
  ) {
    return _apiClientService.getDialogs(payload);
  }

  Future<Result<PaginatedApiResult<Dialog>>> getRecentDialogs(
    String userId,
    RecentDialogsPayload payload,
  ) {
    return _apiClientService.getRecentDialogs(userId, payload);
  }

  Future<Result<Dialog?>> getDialogDetail(DialogDetailPayload payload) {
    return _apiClientService.getDialogDetail(payload);
  }
}
