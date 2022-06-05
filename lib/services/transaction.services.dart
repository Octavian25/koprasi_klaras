import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koperasi_klaras/models/add_transaction.model.dart';
import 'package:koperasi_klaras/models/monthly_fee_model.dart';
import 'package:koperasi_klaras/models/user.model.dart';
import 'package:koperasi_klaras/services/balance.services.dart';
import 'package:koperasi_klaras/services/notification_handler.service.dart';
import 'package:koperasi_klaras/services/user.services.dart';
import 'package:supercharged/supercharged.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("history_transaction");

  CollectionReference firestoreFee =
      FirebaseFirestore.instance.collection("monthly_fee_balance");

  CollectionReference firestoreUser =
      FirebaseFirestore.instance.collection("users");

  Future<bool> addTransaction(
      String nama, int nominal, String paymentMethod, String? tanggal) async {
    try {
      String id = await UserService().getUidByName(nama);
      String uuid = const Uuid().v4();
      firestore.doc(uuid).set(AddTransactionModel(
              nama: nama,
              payment_method: paymentMethod,
              kode_transaksi: uuid,
              id: id,
              type: "ADD",
              nominal: nominal,
              input_date: tanggal ?? DateTime.now().toString(),
              input_by: "ADMIN",
              status: "VALID",
              valid_by: "ADMIN",
              valid_date: tanggal ?? DateTime.now().toString(),
              bukti_pembayaran: "-")
          .toJson());
      await BalanceService()
          .updateBalance(uid: id, nominal: nominal, isAdd: true);
      await NotificationService().sendNotitication(
          name: nama.split("/")[0].trim(),
          nominal: nominal,
          title: "Tambah Saldo Berhasil",
          type: "Menambahkan");
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot<Object?>> streamHistory() {
    return firestore.snapshots();
  }

  Future<bool> updateTransaction(
      {required AddTransactionModel data, required String id}) async {
    try {
      await firestore.doc(id).set(data.toJson());
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> withdrawTransaction(
      String nama, String id, int nominal, String? tanggal) async {
    try {
      String uuid = const Uuid().v4();
      firestore.doc(uuid).set(AddTransactionModel(
              nama: nama,
              payment_method: "Withdraw",
              id: id,
              kode_transaksi: uuid,
              type: "WITHDRAW",
              nominal: nominal,
              input_date: tanggal ?? DateTime.now().toString(),
              input_by: id,
              status: "NOT VALID",
              valid_by: "-",
              valid_date: "-",
              bukti_pembayaran: "-")
          .toJson());
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> monthlyFeeTransactionHistory(
      String nama, String id, int nominal, String? tanggal) async {
    try {
      String uuid = const Uuid().v4();
      firestore.doc(uuid).set(AddTransactionModel(
              nama: nama,
              payment_method: "Withdraw",
              id: id,
              kode_transaksi: uuid,
              type: "MONTHLY FEE",
              nominal: nominal,
              input_date: tanggal ?? DateTime.now().toString(),
              input_by: "ADMIN",
              status: "VALID",
              valid_by: "ADMIN",
              valid_date: tanggal ?? DateTime.now().toString(),
              bukti_pembayaran: "-")
          .toJson());
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loanOutTransaction(
      String nama, String id, int nominal, String? tanggal) async {
    try {
      String uuid = const Uuid().v4();
      firestore.doc(uuid).set(AddTransactionModel(
              nama: nama,
              payment_method: "LOAN-OUT",
              id: id,
              kode_transaksi: uuid,
              type: "LOAN-OUT",
              nominal: nominal,
              input_date: tanggal ?? DateTime.now().toString(),
              input_by: id,
              status: "NOT VALID",
              valid_by: "-",
              valid_date: "-",
              bukti_pembayaran: "-")
          .toJson());
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loanInTransaction(
      String nama, String id, int nominal, String? tanggal) async {
    try {
      String uuid = const Uuid().v4();
      firestore.doc(uuid).set(AddTransactionModel(
              nama: nama,
              payment_method: "LOAN-IN",
              id: id,
              kode_transaksi: uuid,
              type: "LOAN-IN",
              nominal: nominal,
              input_date: tanggal ?? DateTime.now().toString(),
              input_by: id,
              status: "NOT VALID",
              valid_by: "-",
              valid_date: "-",
              bukti_pembayaran: "-")
          .toJson());
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> checkMontlyFee({required String id}) async {
    var response = await firestoreFee.get();
    List<MonthlyFeeModel> listBalance = [];
    String today = DateTime.now().toString().substring(0, 10);
    List<Map<String, dynamic>> raw =
        response.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    if (raw.isNotEmpty) {
      listBalance = raw.map((e) => MonthlyFeeModel.fromJson(e)).toList();
    }
    int index = listBalance.indexWhere(
        (element) => element.id == id && element.month == today.split("-")[1]);
    if (index == -1) {
      monthlyFeeTransaction(id: id, month: today.split("-")[1]);
    }
  }

  Future<void> batchMontlyFee(void _) async {
    var response = await firestoreUser.get();
    List<UserModel> listUser = [];
    String today = DateTime.now().toString().substring(0, 10);
    List<Map<String, dynamic>> raw =
        response.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    if (raw.isNotEmpty) {
      listUser = raw.map((e) => UserModel.fromJson(e)).toList();
    }
    for (UserModel data in listUser.filter((x) => x.role != "ADMIN")) {
      bool isExist =
          await monthlyFeeTransaction(id: data.id, month: today.split("-")[1]);
      if (isExist) {
        await monthlyFeeTransactionHistory(data.name, data.id, 20000, today);
        await BalanceService().moveBalanceMonthlyFee(fee: 20000, id: data.id);
      }
    }
  }

  Future<bool> monthlyFeeTransaction(
      {required String id, required String month}) async {
    var repo = await firestoreFee.get();
    List<Map<String, dynamic>> response =
        await repo.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    List<MonthlyFeeModel> listMonthly =
        response.map((e) => MonthlyFeeModel.fromJson(e)).toList();
    int index = listMonthly
        .indexWhere((element) => element.id == id && element.month == month);
    if (index == -1) {
      firestoreFee
          .add(MonthlyFeeModel(nominal: 20000, id: id, month: month).toJson());
      return true;
    } else {
      return false;
    }
  }
}
