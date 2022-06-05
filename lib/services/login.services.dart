import 'package:firebase_auth/firebase_auth.dart';
import 'package:koperasi_klaras/models/auth_feedback.model.dart';

class LoginService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<AuthFeedbackModel> doLogin(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthFeedbackModel(null, firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e) {
      return AuthFeedbackModel(e.code, null);
    }
  }
}
