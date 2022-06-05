import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:koperasi_klaras/models/user.model.dart';
import 'package:koperasi_klaras/shared/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  Future<void> setInit() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("init", false);
  }

  Future<bool> getInit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("init") ?? true;
  }

  Future<void> createSubcribedToFirebase(
      String uid, UserModel userModel) async {
    await FirebaseMessaging.instance.subscribeToTopic("global");
    await FirebaseMessaging.instance
        .subscribeToTopic(userModel.name.replaceAll(" ", "_"));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1235,
          channelKey: R.cons.channelKey,
          title: message.notification?.title,
          body: message.notification?.body,
          notificationLayout: NotificationLayout.BigText,
        ),
      );
    });
  }

  Future<void> sendNotitication(
      {required String name,
      required int nominal,
      required String title,
      required String type}) async {
    print("PREPARING NOTIFICATION");
    var dio = Dio();
    dio.options.headers['Authorization'] =
        "key=AAAAh4asEKY:APA91bFWIKOC54fpKSU9LJeTJ5M0iY-iY_VWM1gGSAohtY6uKjY1KlOu6eqYi6u4d21LMaPMBMzFJkf26Wa8ZgNZX3BBh9t58xqbwIcKTSdFh7ugoCWgHkjQW7SG_at_2QHEGxSNHDh7";

    try {
      var response =
          await dio.post("https://fcm.googleapis.com/fcm/send", data: {
        "to": "/topics/${name.replaceAll(" ", "_")}",
        "mutable_content": false,
        "content_available": true,
        "priority": "HIGH",
        "collapse_key": "type_a",
        "data": {
          "content": {
            "id": 100,
            "channelKey": "klaras_channel",
            "title": title,
            "body":
                "Anda Baru Saja $type Dana Sebesar ${NumberFormat.currency(decimalDigits: 0, symbol: "Rp. ").format(nominal)}",
            "notificationLayout": "BigText",
            "showWhen": true,
            "autoDismissible": true,
            "privacy": "Private"
          },
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<void> sendMonthlyNotitication(
      {required String name,
      required int nominal,
      required String title,
      required String type}) async {
    print("PREPARING NOTIFICATION");
    var dio = Dio();
    dio.options.headers['Authorization'] =
        "key=AAAAh4asEKY:APA91bFWIKOC54fpKSU9LJeTJ5M0iY-iY_VWM1gGSAohtY6uKjY1KlOu6eqYi6u4d21LMaPMBMzFJkf26Wa8ZgNZX3BBh9t58xqbwIcKTSdFh7ugoCWgHkjQW7SG_at_2QHEGxSNHDh7";

    try {
      var response =
          await dio.post("https://fcm.googleapis.com/fcm/send", data: {
        "to": "/topics/global",
        "mutable_content": false,
        "content_available": true,
        "priority": "HIGH",
        "collapse_key": "type_a",
        "data": {
          "content": {
            "id": 100,
            "channelKey": "klaras_channel",
            "title": title,
            "body":
                "Selamat Bulan Baru, Saldo Anda Sebesar ${NumberFormat.currency(decimalDigits: 0, symbol: "Rp. ").format(20000)} Akan Kami Simpan Ya..",
            "notificationLayout": "BigText",
            "showWhen": true,
            "autoDismissible": true,
            "privacy": "Private"
          },
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }
}
