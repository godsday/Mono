import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/storage/encrption/hive_encryption_service.dart';
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:mono/providers/locale_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mono/features/add_screen/data/repositories/category_db.dart';
import 'package:mono/providers/theme_provider.dart';
import 'package:mono/routes/app_router.dart';
import 'package:mono/routes/route_names.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/features/transaction/data/datasources/transaction_local_data_source.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'providers/notification_provider.dart';
import 'package:mono/features/financial_overview/asset/presentation/providers/assets_provider.dart';
import 'package:mono/features/financial_overview/goals/presentation/providers/goals_provider.dart';
import 'package:mono/features/financial_overview/budget/presentation/providers/add_budget_provider.dart';
import 'package:mono/features/financial_overview/budget/presentation/providers/budget_provider.dart';
import 'package:mono/features/financial_overview/analytics/presentation/providers/wealth_analytics_provider.dart';
import 'package:mono/features/app_settings/presentation/providers/app_settings_provider.dart';

import 'package:mono/core/di/injection_container.dart' as di;
import 'package:mono/core/di/injection_container.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, initialize Firebase
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  // You could also show a local notification here using flutter_local_notifications
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrintRebuildDirtyWidgets = true;
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  await HiveService.init();
  await di.init();

  await TransactionLocalDataSourceImpl.instance.getTransactions();
  await CategoryDB.instance.initializeCategories();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => sl<DarkThemeProvider>()),
      ChangeNotifierProvider(create: (_) => sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (_) => sl<LocaleProvider>()),
      ChangeNotifierProvider(
        create: (_) => AppSettingsProvider(
          getAppSettingsUseCase: sl(),
          updateLanguageUseCase: sl(),
          updateCurrencyUseCase: sl(),
        ),
      ),
      ChangeNotifierProvider(
          create: (_) => TransactionProvider(
                totalBalanceUseCase: sl(),
                totalIncomeUseCase: sl(),
                totalExpenseUseCase: sl(),
                getTransactionsUseCase: sl(),
                addTransactionUseCase: sl(),
                deleteTransactionUseCase: sl(),
                updateTransactionUseCase: sl(),
                groupTransactionsUseCase: sl(),
              )),
      ChangeNotifierProxyProvider2<TransactionProvider, NotificationProvider,
          HomeProvider>(
        create: (_) => HomeProvider(
          getCurrentMonthBudgetUseCase: sl(),
          generateInsightsUseCase: sl(),
          getTopCategoriesUseCase: sl(),
          calculateThisMonth: sl(),
          totalBalanceUseCase: sl(),
          totalIncomeUseCase: sl(),
          totalExpenseUseCase: sl(),
        ),
        update:
            (context, transactionProvider, notificationProvider, homeProvider) {
          homeProvider!.updateNotificationProvider(notificationProvider);
          homeProvider.updateTransactions(transactionProvider.transactions);
          return homeProvider;
        },
      ),
      ChangeNotifierProvider(
          create: (_) => AddBudgetProvider(
                saveBudgetUseCase: sl(),
              )),
      ChangeNotifierProvider(
          create: (_) => BudgetProvider(
                getTransactions: sl(),
                getBudgetUseCase: sl(),
              )),
      ChangeNotifierProvider(
          create: (_) => AssetsProvider(
                getAssetsUseCase: sl(),
                addAssetUseCase: sl(),
                deleteAssetUseCase: sl(),
              )),
      ChangeNotifierProxyProvider<NotificationProvider, GoalsProvider>(
        create: (_) => GoalsProvider(
          getGoalsUseCase: sl(),
          addGoalUseCase: sl(),
          updateGoalProgressUseCase: sl(),
        ),
        update: (context, notificationProvider, goalsProvider) {
          goalsProvider!.updateNotificationProvider(notificationProvider);
          return goalsProvider;
        },
      ),
      ChangeNotifierProvider(create: (_) => WealthAnalyticsProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final themeProvider =
          Provider.of<DarkThemeProvider>(context, listen: false);
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);

      themeProvider.darkTheme =
          await themeProvider.darkThemePreferences.getTheme();
      notificationProvider.notifValue =
          await notificationProvider.notificationPreference.getnotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Consumer2<DarkThemeProvider, LocaleProvider>(
          builder: (context, darkThemeValue, localeValue, child) {
        return MaterialApp(
          locale: localeValue.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.all,
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(darkThemeValue.darkTheme, context),
          initialRoute: RouteNames.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
          themeMode: ThemeMode.system,
        );
      });
    });
  }
}
