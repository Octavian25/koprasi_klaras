import 'package:flutter/material.dart';
import 'package:koperasi_klaras/models/register_feedback.model.dart';
import 'package:koperasi_klaras/providers/loading.provider.dart';
import 'package:koperasi_klaras/services/register.services.dart';

class RegisterProvider extends ChangeNotifier {
  LoadingProvider? loadingProvider;
  RegisterFeedbackModel? registerFeedbackModel;

  void initLoaidng(LoadingProvider? loadingProvider) {
    this.loadingProvider = loadingProvider;
  }

  Future<bool> register(
      String email, String password, String name, String blok) async {
    loadingProvider!.startLoading();
    RegisterFeedbackModel res =
        await RegisterService().doRegister(email, password, name, blok);
    if (res.isSuccess) {
      registerFeedbackModel = res;
      loadingProvider!.endLoading();
      notifyListeners();
      return true;
    } else {
      registerFeedbackModel = res;
      loadingProvider!.endLoading();
      notifyListeners();
      return false;
    }
  }
}
