import 'package:zingo/config/dio_http.dart';
import 'package:zingo/dtos/dialog-turns/dialog_turns_by_dialog_id_payload.dart';
import 'package:zingo/interfaces/api_response.dart';
import 'package:zingo/models/dialog_turn.dart';

class DialogTurnsService {
  Future<List<DialogTurn>?> getDialogTurnsByDialogId(
    DialogTurnsByDialogIdPayload payload,
  ) async {
    try {
      final response = await dio.get(
        '/v1/dialog-turns/${payload.dialogId}/turns',
      );
      final result = ApiResponse.fromJson(response.data);
      if (result.success) {
        final data = result.data as List<dynamic>?;
        if (data == null) {
          return null;
        }
        return data.map((item) => DialogTurn.fromJson(item)).toList();
      } else {
        throw Exception(result.error);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
