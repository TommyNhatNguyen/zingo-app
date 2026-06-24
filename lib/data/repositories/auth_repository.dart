import 'package:firebase_auth/firebase_auth.dart';
import 'package:zingo/data/model/result.dart';
import 'package:zingo/data/services/api_client_service.dart';
import 'package:zingo/data/services/firebase_auth_service.dart';
import 'package:zingo/domain/dtos/auth/login_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_from_anonymous_dto.dart';
import 'package:zingo/domain/dtos/users/users_create_from_login_google_dto.dart';
import 'package:zingo/domain/models/users.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final ApiClientService _apiClientService;

  AuthRepository({
    required FirebaseAuthService firebaseAuthService,
    required ApiClientService apiClientService,
  }) : _firebaseAuthService = firebaseAuthService,
       _apiClientService = apiClientService;

  Future<User?> loginWithEmailAndPassword(LoginDto payload) {
    return _firebaseAuthService.loginWithEmailAndPassword(payload);
  }

  Future<User?> loginWithGoogle() {
    return _firebaseAuthService.loginWithGoogle();
  }

  Future<User?> loginWithAnonymous() {
    return _firebaseAuthService.loginWithAnonymous();
  }

  Future<Result<Users?>> getUserByUid() {
    return _apiClientService.getUserByUid();
  }

  Future<Result<Users?>> registerWithGoogle(
    UsersCreateFromLoginGoogleDto payload,
  ) {
    return _apiClientService.registerWithGoogle(payload);
  }

  Future<Result<Users?>> registerWithAnonymous(
    UsersCreateFromAnonymousDto payload,
  ) {
    return _apiClientService.registerWithAnonymous(payload);
  }

  Future<void> logout() {
    return _firebaseAuthService.logout();
  }
}
