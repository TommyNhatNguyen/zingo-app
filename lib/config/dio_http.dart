import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://127.0.0.1:3000',
    // baseUrl: 'http://192.168.1.248:3000',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ),
)..interceptors.add(_FirebaseAuthInterceptor());

class _FirebaseAuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.statusCode == 401) {
      FirebaseAuth.instance.signOut();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      FirebaseAuth.instance.signOut();
    }
    handler.next(err);
  }
}
