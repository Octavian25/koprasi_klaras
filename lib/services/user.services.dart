import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koperasi_klaras/models/user.model.dart';
import 'package:supercharged/supercharged.dart';

class UserService {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("users");
  Future<List<String>> streamAllUser() async {
    var res = await firestore.get();
    List<Map<String, dynamic>> data = res.docs
        .map((e) => e.data() as Map<String, dynamic>)
        .toList()
        .filter((x) => x['role'] != "ADMIN")
        .toList();
    return data.map((e) => "${e['nama']} / ${e['blok_rumah']}").toList();
  }

  Future<String> getUidByName(String param) async {
    var name = param.split("/")[0].trim();
    var blok_rumah = param.split("/")[1].trim();
    var response = await firestore
        .where("nama", isEqualTo: name)
        .where("blok_rumah", isEqualTo: blok_rumah)
        .get();
    List<Map<String, dynamic>> data =
        response.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    return data[0]['id'];
  }

  Future<UserModel> getUserInfo(String uid) async {
    var response = await firestore.where("id", isEqualTo: uid).get();
    List<Map<String, dynamic>> data =
        response.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    return UserModel.fromJson(data[0]);
  }

  Future<void> setToken(String uid, UserModel userModel) async {
    firestore.doc(uid).set(userModel.toJson());
  }

  Future<void> setLogout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
  }
}
