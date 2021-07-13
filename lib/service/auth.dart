import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshwatch/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  UserData _userFromFirebaseUser(User? user) {
    return user != null ? UserData(uid: user.uid) : UserData();
  }

  // auth change user stream
  Stream<UserData> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future<String?> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  // sign in with google account authentication

}