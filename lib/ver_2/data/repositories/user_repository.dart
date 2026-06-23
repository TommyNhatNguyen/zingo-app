import 'package:zingo/models/users.dart';
import 'package:zingo/ver_2/data/model/result.dart';
import 'package:zingo/ver_2/data/services/api_client_service.dart';

class UserRepository {
  final ApiClientService _apiClientService;

  const UserRepository({required ApiClientService apiClientService})
    : _apiClientService = apiClientService;

}
