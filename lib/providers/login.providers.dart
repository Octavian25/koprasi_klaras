import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koperasi_klaras/models/auth_feedback.model.dart';
import 'package:koperasi_klaras/models/user.model.dart';
import 'package:koperasi_klaras/providers/loading.provider.dart';
import 'package:koperasi_klaras/services/balance.services.dart';
import 'package:koperasi_klaras/services/login.services.dart';
import 'package:koperasi_klaras/services/user.services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  LoadingProvider? loadingProvider;
  User? user;
  UserModel? userModel;
  String? code;
  int? balance;
  int? balanceGlobal;

  static const EMAILKEY = "email";
  static const PASSKEY = "password";

  void initLoading(LoadingProvider? loadingProvider) {
    this.loadingProvider = loadingProvider;
  }

  Future<bool> login(String email, String password, bool isSaveData) async {
    loadingProvider!.startLoading();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    AuthFeedbackModel response = await LoginService().doLogin(email, password);
    print(response.user);
    if (response.user != null) {
      user = response.user;
      UserModel userModel = await UserService().getUserInfo(user!.uid);
      int balance = await BalanceService().getBalance(user!.uid);
      int balanceGlobal = await BalanceService().getGlobalBalance();
      this.userModel = userModel;
      this.balance = balance;
      this.balanceGlobal = balanceGlobal;
      if (isSaveData) {
        preferences.setString(EMAILKEY, email);
        preferences.setString(PASSKEY, password);
      }
      loadingProvider!.endLoading();
      notifyListeners();
      return true;
    }
    code = response.code;
    loadingProvider!.endLoading();
    notifyListeners();
    return false;
  }

  void updateBalance() async {
    int balance = await BalanceService().getBalance(user!.uid);
    this.balance = balance;
    notifyListeners();
  }

  Future<void> logout() async {
    loadingProvider!.startLoading();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await UserService().setLogout();
    user = null;
    userModel = null;
    code = null;
    balance = 0;
    preferences.remove(EMAILKEY);
    preferences.remove(PASSKEY);
    loadingProvider!.endLoading();
    notifyListeners();
  }
}
