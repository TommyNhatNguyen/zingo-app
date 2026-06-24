import 'package:zingo/data/model/api_response.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/user-favorite-dialogs/list_favorite_dialogs_payload.dart';
import 'package:zingo/domain/dtos/users/users_favorite_dialog_dto.dart';
import 'package:zingo/domain/models/user_dialog_favorite.dart';

class FavoriteDialogRepository {
  final ApiClientService _apiClientService;

  FavoriteDialogRepository({required ApiClientService apiClientService})
      : _apiClientService = apiClientService;

  Future<Result<PaginatedApiResult<UserDialogFavorite>>> getFavoriteDialogs(
    ListFavoriteDialogsPayload payload,
  ) {
    return _apiClientService.getFavoriteDialogs(payload);
  }

  Future<Result<bool>> addFavorite(UsersFavoriteDialogDto payload) {
    return _apiClientService.addFavorite(payload);
  }

  Future<Result<bool>> removeFavorite(UsersFavoriteDialogDto payload) {
    return _apiClientService.removeFavorite(payload);
  }
}
