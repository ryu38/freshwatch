import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshwatch/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  UserData _userFromFirebaseUser(User? user) {
    return UserData(uid: user?.uid, email: user?.email);
  }

  // auth change user stream
  Stream<UserData> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  // Google auth
  Future<User?> signInGoogle() async {
    try {
      final account = await GoogleSignIn().signIn();
      if (account == null) {
        return null;
      }
      final googleAuth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // sign out
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}