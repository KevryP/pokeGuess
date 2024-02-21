import 'package:firebase_auth/firebase_auth.dart';
import 'package:poke_guess/FirebaseDatabaseService.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabaseService _db = FirebaseDatabaseService();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential> emailSignIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> emailSignUp(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    _db.addUser(email);
    return result;
  }
}
