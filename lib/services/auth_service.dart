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
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final result = await firebase.signInWithCredential(credential);
    final user = result.user;
    return user;
  }

  Future<User?> registerWithEmailAndPassword(RegisterDto payload) async {
    final result = await firebase.createUserWithEmailAndPassword(
      email: payload.email,
      password: payload.password,
    );
    return result.user;
  }
}
