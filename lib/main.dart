import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koperasi_klaras/firebase_options.dart';
import 'package:koperasi_klaras/pages/pages.dart';
import 'package:koperasi_klaras/providers/balance.provider.dart';
import 'package:koperasi_klaras/providers/loading.provider.dart';
import 'package:koperasi_klaras/providers/login.providers.dart';
import 'package:koperasi_klaras/providers/register.provider.dart';
import 'package:koperasi_klaras/shared/resources.dart';
import 'package:provider/provider.dart';

Future<void> _FirebaseHandler(RemoteMessage message) async {
  print("Message from Firebase ${message.messageId}");
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  print("Handling a background message: ${message.messageId}");
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: R.cons.channelKey,
            channelName: R.cons.channelName,
            channelDescription: R.cons.channelDesc,
            channelGroupKey: R.cons.channelGroupKey,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            importance: NotificationImportance.Max),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: R.cons.channelGroupKey,
            channelGroupName: R.cons.channelGroupName)
      ],
      debug: true);
  FirebaseMessaging.onMessage.listen(_FirebaseHandler);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoadingProvider()),
        ChangeNotifierProxyProvider<LoadingProvider, LoginProvider>(
            create: (_) => LoginProvider(),
            update: (_, loading, loginProvider) =>
                loginProvider!..initLoading(loading)),
        ChangeNotifierProxyProvider<LoadingProvider, RegisterProvider>(
            create: (_) => RegisterProvider(),
            update: (_, loading, registerProvider) =>
                registerProvider!..initLoaidng(loading)),
        ChangeNotifierProxyProvider<LoadingProvider, BalanceProvider>(
            create: (_) => BalanceProvider(),
            update: (_, loading, balanceProvider) =>
                balanceProvider!..initLoading(loading)),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_) {
            return MaterialApp(
              title: 'Koperasi Klaras',
              useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: GoogleFonts.openSansTextTheme()),
              routes: {
                "/": (context) => BasePage(child: const OnBoardPage()),
                "/home": (context) => BasePage(child: const HomePage()),
                "/home_admin": (context) =>
                    BasePage(child: const AdminHomePage()),
                "/add_balance": (context) =>
                    BasePage(child: const AddBalance()),
                "/withdraw_balance": (context) =>
                    BasePage(child: const WithdrawBalance()),
                "/loan_balance": (context) =>
                    BasePage(child: const LoanBalance()),
                "/login": (context) => BasePage(child: const LoginPage()),
              },
            );
          }),
    );
  }
}
