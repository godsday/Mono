import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/models/transcation_model/transcation_model.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/providers/theme_provider.dart';
import 'package:mono/screens/IntroPages/splash_screen.dart';
import 'package:mono/screens/widgets/theme.dart';
import 'package:mono/ts/presentation/spending_dashboard_screen/provider/spending_dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'providers/notification_provider.dart';

Timer? fightTimer;
DarkThemeProvider themeChangeProvider = DarkThemeProvider();
NotificationProvider notificationProvider = NotificationProvider();
AppState appState = AppState();
SpendingDashboardProvider spendingDashboardProvider =
    SpendingDashboardProvider();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(TranscationModelAdapter().typeId)) {
    Hive.registerAdapter(TranscationModelAdapter());
  }

  await TranscationDB.instance.getalltranscation();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) {
        return appState;
      }),
      ChangeNotifierProvider(create: (_) {
        return themeChangeProvider;
      }),
      ChangeNotifierProvider(create: (_) {
        return notificationProvider;
      }),
      ChangeNotifierProvider(create: (_) {
        return spendingDashboardProvider;
      })
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void getCurrentNotification() async {
    notificationProvider.notifValue =
        await notificationProvider.notificationPreference.getnotification();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await checkflight(context);
      final list = await TranscationDB.instance.getalltranscation();
      if (mounted) {
        Provider.of<AppState>(context, listen: false).totalBalanceCheck(list);
      } // await Provider.of<AppState>(context, listen: false).refresh();
    });
    scheduleMicrotask(() async {});
    getCurrentAppTheme();
    getCurrentNotification();
    // Provider.of<AppState>(context, listen: false).refresh();
    super.initState();
  }

  // Future checkflight(context) async {
  //   String platformVersion;
  //   try {
  //     platformVersion = (await AirplaneModeChecker.platformVersion)!;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }

  //   // try {
  //   //   fightTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
  //   //     final status = await AirplaneModeChecker.checkAirplaneMode();

  //   //     if (status == AirplaneModeStatus.on) {
  //   //       Provider.of<AppState>(context, listen: false).isFilghtMode = true;
  //   //       // isFlight = true;
  //   //       Navigator.of(context).push(MaterialPageRoute(
  //   //         builder: (context) => FlightModeBt(),
  //   //       ));
  //   //       // showbtflight(context);
  //   //       print("------------------------------------t");
  //   //     } else {
  //   //       // isFlight = false;
  //   //       Provider.of<AppState>(context, listen: false).isFilghtMode = false;
  //   //       print("------------------------------------f");
  //   //     }
  //   //   });
  //   // } catch (e) {
  //   //   print(e.toString());
  //   // }
  //   // return isFlight;
  // }

  // showbtflight(context) async {
  // if (Provider.of<AppState>(context, listen: false).isFilghtMode == true) {
  //   if (fightTimer!.isActive) {
  //     await showFightBt(context);
  //     fightTimer!.cancel();
  //   }
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Consumer<DarkThemeProvider>(builder: (context, value, child) {
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('es'), // Spanish (you can add more later)
          ],
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          home: const SplashScreen(),
        );
      });
    });
  }
}
