import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koperasi_klaras/models/register_feedback.model.dart';
import 'package:koperasi_klaras/services/balance.services.dart';

class RegisterService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionUsers =
      FirebaseFirestore.instance.collection("users");
  CollectionReference collectionBalance =
      FirebaseFirestore.instance.collection("balances");
  Future<bool> storeUserToFirestore(
      User? user, String name, String blok) async {
    try {
      collectionUsers.doc(user?.uid).set({
        "email": user!.email,
        "id": user.uid,
        "nama": name,
        "blok_rumah": blok,
        "role": "MEMBER",
        "token": "-"
      });
      await BalanceService().initBalance(user.uid);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<RegisterFeedbackModel> doRegister(
      String email, String password, String name, String blok) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      storeUserToFirestore(firebaseAuth.currentUser, name, blok);
      return RegisterFeedbackModel(
          "Register Berhasil , Silahkan Perikasa Email Anda untuk verifikasi",
          true);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return RegisterFeedbackModel("Password Terlalu Lemah", false);
      } else if (e.code == "email-already-in-use") {
        return RegisterFeedbackModel("Email Sudah Pernah Didaftarkan", false);
      }
      return RegisterFeedbackModel(
          "Error Registrasi Periksa Koneksi Anda", false);
    }
  }
}
