import 'package:firebase_auth/firebase_auth.dart';
import 'package:piper_team_tasks/models/authenticatedUser.dart';
import 'package:piper_team_tasks/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticatedUser _convertFirebaseUsertoUser(FirebaseUser user) {
    return user != null
        ? AuthenticatedUser(uid: user.uid, email: user.email)
        : null;
  }

  // auth change user stream
  Stream<AuthenticatedUser> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _convertFirebaseUsertoUser(user));
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      if (error.toString() == "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
        return 1;
      } else {
      print("spacer "+ error.toString() + " spacer");
      return null;
      }
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      // Add this newly created user to the Database and pass their uid and email to store
      await DatabaseService(uid: user.uid).addUserToDatabase(email);

      return _convertFirebaseUsertoUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
