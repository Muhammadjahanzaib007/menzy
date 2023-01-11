import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:menzy/dbhelper/DataBaseHelper.dart';
import 'package:menzy/firebase_options.dart';
import 'package:menzy/utils/Color.dart';
import 'package:menzy/utils/Debug.dart';
import 'package:menzy/utils/Preference.dart';
import 'package:menzy/utils/Theme-Color.dart';
import 'package:rxdart/subjects.dart';

import 'Controllers/auth-controller.dart';
import 'Repository/user_repository.dart';
import 'Services/deep_link_service.dart';
import 'Services/notification_service.dart';
import 'View/splash_screen.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';




late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Preference().instance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DataBaseHelper().initialize();

  runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(
      MyApp(),
    );
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
  // configLoading();
}
//
// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.circle
//     ..loadingStyle = EasyLoadingStyle.light
//     ..indicatorSize = 25.0
//     ..radius = 10.0
//     ..backgroundColor = Colors.transparent
//     ..boxShadow = <BoxShadow>[]
//     ..indicatorColor = Colors.transparent
//     ..maskColor = Colors.transparent
//     ..userInteractions = false
//     ..dismissOnTap = false;
// }



class MyApp extends StatefulWidget {
  // static final navigatorKey = new GlobalKey<NavigatorState>();
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  bool isFirstTimeUser = true;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void didChangeDependencies() async {
    _locale = getLocale();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    isFirstTime();
    super.initState();
  }

  isFirstTime() async {
    isFirstTimeUser =
        Preference.shared.getBool(Preference.IS_USER_FIRSTTIME) ?? true;
    Debug.printLog("==>>" + isFirstTimeUser.toString());
    Preference.shared.setBool(Preference.IS_USER_FIRSTTIME, false);
  }
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    return GetMaterialApp(
      // navigatorKey: MyApp.navigatorKey,
      builder: EasyLoading.init(),
      theme: ThemeData(
        splashColor: Colur.transparent,
        highlightColor: Colur.transparent,
        fontFamily: 'Roboto',
        primarySwatch: ThemeColor.pink,
      ),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('pt', ''),
        Locale('ar', ''),
        Locale('fr', ''),
        Locale('ja', ''),
        Locale('ru', ''),
        Locale('ur', ''),
        Locale('hi', ''),
        Locale('vi', ''),
        Locale('id', ''),
        Locale('bn', ''),
        Locale('ta', ''),
        Locale('te', ''),
        Locale('tr', ''),
        Locale('ko', ''),
        Locale('pa', ''),
        Locale('it', ''),
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colur.white, brightness: Brightness.light),
        appBarTheme: AppBarTheme(
          backgroundColor: Colur.transparent,
        ),
      ),
      home: FutureBuilder(
        future: authController.checkUserLoggedIn(),
        builder: (context, dynamic snapshot) {
          return snapshot.data;
        },
        initialData: const SplashScreen(),
      ),
    );
  }
}
