import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';

class TestRepository {
  final ApiClientService _apiClientService;

  const TestRepository({required ApiClientService apiClientService})
    : _apiClientService = apiClientService;

  Future<Result<dynamic>> test() async {
    return await _apiClientService.test();
  }
}
