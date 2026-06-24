import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/domain/models/dialog_turn.dart';

class DialogTurnsRepository {
  final ApiClientService _apiClientService;

  DialogTurnsRepository({required ApiClientService apiClientService})
      : _apiClientService = apiClientService;

  Future<Result<List<DialogTurn>?>> getDialogTurnsByDialogId(
    DialogTurnsByDialogIdPayload payload,
  ) {
    return _apiClientService.getDialogTurnsByDialogId(payload);
  }
}
