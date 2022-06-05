import 'package:flutter/cupertino.dart';
import 'package:koperasi_klaras/models/add_transaction.model.dart';
import 'package:koperasi_klaras/models/user.model.dart';
import 'package:koperasi_klaras/providers/loading.provider.dart';
import 'package:koperasi_klaras/services/balance.services.dart';
import 'package:koperasi_klaras/services/notification_handler.service.dart';
import 'package:koperasi_klaras/services/transaction.services.dart';

class BalanceProvider with ChangeNotifier {
  LoadingProvider? loadingProvider;
  int? loanAvailable;

  void initLoading(LoadingProvider? loadingProvider) {
    this.loadingProvider = loadingProvider;
  }

  Future<bool> adminAction(
      AddTransactionModel data, UserModel userModel) async {
    loadingProvider!.startLoading();
    loadingProvider!.notifyListeners();
    switch (data.type) {
      case "WITHDRAW":
        await BalanceService()
            .updateBalance(uid: data.id, nominal: data.nominal, isAdd: false);
        var update = data.copyWith(
            status: "VALID",
            valid_by: userModel.id,
            valid_date: DateTime.now().toString());
        await TransactionService()
            .updateTransaction(data: update, id: data.kode_transaksi);
        await NotificationService().sendNotitication(
            name: data.nama.split("/")[0].trim(),
            nominal: data.nominal,
            title: "Pengajuan Ambil Saldo Berhasil",
            type: "Mengambil");
        loadingProvider!.endLoading();
        loadingProvider!.notifyListeners();
        return true;
      case "LOAN-OUT":
        {
          await BalanceService()
              .loanGlobalBalance(nominal: data.nominal, isAdd: false);
          loanAvailable = await BalanceService().getLoanBalance();
          var update = data.copyWith(
              status: "VALID",
              valid_by: userModel.id,
              valid_date: DateTime.now().toString());
          await TransactionService()
              .updateTransaction(data: update, id: data.kode_transaksi);
          notifyListeners();
          loadingProvider!.endLoading();
          loadingProvider!.notifyListeners();
          return true;
        }
      case "LOAN-IN":
        {
          await BalanceService()
              .loanGlobalBalance(nominal: data.nominal, isAdd: true);
          loanAvailable = await BalanceService().getLoanBalance();
          var update = data.copyWith(
              status: "VALID",
              valid_by: userModel.id,
              valid_date: DateTime.now().toString());
          await TransactionService()
              .updateTransaction(data: update, id: data.kode_transaksi);
          notifyListeners();
          loadingProvider!.endLoading();
          loadingProvider!.notifyListeners();
          return true;
        }
    }
    return false;
  }

  Future<bool> getMonthlyFee() async {
    try {
      await TransactionService().batchMontlyFee(null);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
