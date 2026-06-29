import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/domain/dtos/user-configuration/user_configuration_update_dto.dart';
import 'package:zingo/domain/models/user_configuration.dart';

class UserConfigurationRepository {
  final ApiClientService _apiClientService;

  UserConfigurationRepository({required ApiClientService apiClientService})
    : _apiClientService = apiClientService;

  Future<Result<UserConfiguration?>> getUserConfiguration() {
    return _apiClientService.getUserConfiguration();
  }

  Future<Result<UserConfiguration?>> updateUserConfiguration(
    UserConfigurationUpdateDto payload,
  ) {
    return _apiClientService.updateUserConfiguration(payload);
  }
}
