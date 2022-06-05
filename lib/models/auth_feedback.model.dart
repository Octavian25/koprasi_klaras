import 'package:firebase_auth/firebase_auth.dart';

class AuthFeedbackModel {
  String? code;
  User? user;

  AuthFeedbackModel(this.code, this.user);
}
