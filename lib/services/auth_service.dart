import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zingo/dtos/auth/login_dto.dart';
import 'package:zingo/dtos/auth/register_dto.dart';

class AuthService {
  final FirebaseAuth firebase = FirebaseAuth.instance;
  Future<User?> loginWithEmailAndPassword(LoginDto payload) async {
    final result = await firebase.signInWithEmailAndPassword(
      email: payload.email,
      password: payload.password,
    );
    final user = result.user;
    return user;
  }

  Future<User?> loginWithGoogle() async {
    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final result = await firebase.signInWithCredential(credential);
    return result.user;
  }

  Future<User?> registerWithEmailAndPassword(RegisterDto payload) async {
    final result = await firebase.createUserWithEmailAndPassword(
      email: payload.email,
      password: payload.password,
    );
    return result.user;
  }

  Future<User?> loginWithAnonymous() async {
    final result = await firebase.signInAnonymously();
    return result.user;
  }
}
