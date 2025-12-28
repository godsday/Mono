import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:mono/providers/locale_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/database/categories_DB/category_db.dart';
import 'package:mono/models/transcation_model/transcation_model.dart';
import 'package:mono/models/category_model/category_model.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/providers/theme_provider.dart';
import 'package:mono/routes/app_router.dart';
import 'package:mono/routes/route_names.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/features/transaction/data/datasources/transaction_local_data_source.dart';
import 'package:mono/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:mono/features/transaction/domain/usecases/add_transaction.dart';
import 'package:mono/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:mono/features/transaction/domain/usecases/get_transactions.dart';
import 'package:mono/features/transaction/domain/usecases/update_transaction.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'providers/notification_provider.dart';
import 'package:mono/features/financial_overview/assets/data/repositories/asset_repository_impl.dart';
import 'package:mono/features/financial_overview/assets/domain/usecases/add_asset_usecase.dart';
import 'package:mono/features/financial_overview/assets/domain/usecases/delete_asset_usecase.dart';
import 'package:mono/features/financial_overview/assets/domain/usecases/get_assets_usecase.dart';
import 'package:mono/features/financial_overview/assets/presentation/providers/assets_provider.dart';
import 'package:mono/features/financial_overview/goals/data/repositories/goal_repository_impl.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/add_goal_usecase.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/get_goals_usecase.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/update_goal_progress_usecase.dart';
import 'package:mono/features/financial_overview/goals/presentation/providers/goals_provider.dart';

DarkThemeProvider themeChangeProvider = DarkThemeProvider();
NotificationProvider notificationProvider = NotificationProvider();
AppState appState = AppState();
LocaleProvider localeProvider = LocaleProvider();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(TranscationModelAdapter().typeId)) {
    Hive.registerAdapter(TranscationModelAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  await TranscationDB.instance.getalltranscation();
  await CategoryDB.instance.initializeCategories();
  await appState.loadCategories();

  // Clean Architecture Setup
  final localDataSource = TransactionLocalDataSourceImpl();
  final repository =
      TransactionRepositoryImpl(localDataSource: localDataSource);
  final getTransactions = GetTransactions(repository);
  final addTransaction = AddTransaction(repository);
  final deleteTransaction = DeleteTransaction(repository);
  final updateTransaction = UpdateTransaction(repository);

  // Assets Setup
  final assetRepository = AssetRepositoryImpl();
  final getAssets = GetAssetsUseCase(assetRepository);
  final addAsset = AddAssetUseCase(assetRepository);
  final deleteAsset = DeleteAssetUseCase(assetRepository);

  // Goals Setup
  final goalRepository = GoalRepositoryImpl();
  final getGoals = GetGoalsUseCase(goalRepository);
  final addGoal = AddGoalUseCase(goalRepository);
  final updateGoalProgress = UpdateGoalProgressUseCase(goalRepository);

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
        return localeProvider;
      }),
      ChangeNotifierProvider(
          create: (_) => TransactionProvider(
                getTransactionsUseCase: getTransactions,
                addTransactionUseCase: addTransaction,
                deleteTransactionUseCase: deleteTransaction,
                updateTransactionUseCase: updateTransaction,
              )),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(
          create: (_) => AssetsProvider(
                getAssetsUseCase: getAssets,
                addAssetUseCase: addAsset,
                deleteAssetUseCase: deleteAsset,
              )),
      ChangeNotifierProvider(
          create: (_) => GoalsProvider(
                getGoalsUseCase: getGoals,
                addGoalUseCase: addGoal,
                updateGoalProgressUseCase: updateGoalProgress,
              )),
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
        );
      });
    });
  }
}
