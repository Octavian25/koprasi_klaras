import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koperasi_klaras/models/balance.model.dart';
import 'package:koperasi_klaras/models/monthly_fee_model.dart';

class BalanceService {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("balances");
  CollectionReference firestoreGlobal =
      FirebaseFirestore.instance.collection("global_balances");
  CollectionReference firestoreLoan =
      FirebaseFirestore.instance.collection("loan_balances");
  CollectionReference firestoreFee =
      FirebaseFirestore.instance.collection("monthly_fee_balance");

  Stream<DocumentSnapshot<Object?>> streamBalance(String uid) {
    return firestore.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot<Object?>> streamGlobalBalance() {
    return firestoreGlobal.doc("GLOBAL").snapshots();
  }

  Future<int> getBalance(String uid) async {
    var response = await firestore.doc(uid).get();
    return response.get('balance');
  }

  Future<int> getLoanBalance() async {
    var response = await firestoreLoan.doc("LOAN").get();
    return response.get('balance');
  }

  Future<void> updateBalance(
      {required String uid, required int nominal, required bool isAdd}) async {
    int prevBalance = await getBalance(uid);
    firestore.doc(uid).set(BalanceModel(
            id: uid,
            balance: isAdd ? prevBalance + nominal : prevBalance - nominal)
        .toJson());
    await updateGlobalBalance();
  }

  Future<void> moveBalanceMonthlyFee(
      {required int fee, required String id}) async {
    var repo = await firestore.doc("monthly-fee").get();
    int recentMonthlyFee = repo.get("balance");
    firestore.doc("monthly-fee").set(
        BalanceModel(id: 'monthly-fee', balance: recentMonthlyFee + fee)
            .toJson());
    updateBalance(uid: id, nominal: 20000, isAdd: false);
  }

  Future<int> getGlobalBalance() async {
    var response = await firestoreGlobal.doc("GLOBAL").get();
    return response.get("balance");
  }

  Future<void> updateGlobalBalance() async {
    var response = await firestore.get();
    List<Map<String, dynamic>> raw =
        response.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    List<int> listBalance = raw.map((e) => e['balance'] as int).toList();
    int totalBalance = listBalance.reduce((value, element) => value + element);
    firestoreGlobal
        .doc("GLOBAL")
        .set(BalanceModel(id: "GLOBAL", balance: totalBalance).toJson());
  }

  Future<void> initBalance(String uid) async {
    await firestore
        .doc("monthly-fee")
        .set(BalanceModel(id: "monthly-fee", balance: 0).toJson());
    await firestore.doc(uid).set(BalanceModel(id: uid, balance: 0).toJson());
    await firestoreGlobal
        .doc("GLOBAL")
        .set(BalanceModel(id: "GLOBAL", balance: 0).toJson());
    await firestoreLoan
        .doc("LOAN")
        .set(BalanceModel(id: "LOAN", balance: 0).toJson());
    await firestoreFee
        .doc("MONTHLY-FEE")
        .set(MonthlyFeeModel(nominal: 0, id: "-", month: "01").toJson());
  }

  Future<void> loanGlobalBalance(
      {required int nominal, required bool isAdd}) async {
    int prevBalance = await getLoanBalance();
    firestoreLoan.doc().set(BalanceModel(
            id: "LOAN",
            balance: isAdd ? prevBalance + nominal : prevBalance - nominal)
        .toJson());
  }
}
