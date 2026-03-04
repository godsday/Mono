import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/storage/encrption/hive_encryption_service.dart';
import 'package:mono/features/financial_overview/budget/data/repositories/budget_repository_impl.dart';
import 'package:mono/features/financial_overview/budget/domain/usecases/get_current_month_budget_usecase.dart';
import 'package:mono/features/financial_overview/budget/domain/usecases/save_monthly_budget_usecase.dart';
import 'package:mono/features/financial_overview/budget/presentation/providers/add_budget_provider.dart';
import 'package:mono/features/financial_overview/budget/presentation/providers/budget_provider.dart';
import 'package:mono/features/home/domain/usecase/smart_insight_usecase.dart';
import 'package:mono/features/transaction/domain/usecases/calcuate_total_income.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_this_month.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_balance.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_expense.dart';
import 'package:mono/features/home/domain/usecase/get_top_categories.dart';
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:mono/providers/locale_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mono/database/categories_DB/category_db.dart';
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
import 'package:mono/features/transaction/domain/usecases/group_transactions_by_date.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'providers/notification_provider.dart';
import 'package:mono/features/financial_overview/asset/data/repositories/asset_repository_impl.dart';
import 'package:mono/features/financial_overview/asset/domain/usecases/add_asset_usecase.dart';
import 'package:mono/features/financial_overview/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:mono/features/financial_overview/asset/domain/usecases/get_assets_usecase.dart';
import 'package:mono/features/financial_overview/asset/presentation/providers/assets_provider.dart';
import 'package:mono/features/financial_overview/goals/data/repositories/goal_repository_impl.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/add_goal_usecase.dart';
import 'package:mono/features/financial_overview/goals/presentation/providers/goals_provider.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/get_goals_usecase.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/update_goal_progress_usecase.dart';

DarkThemeProvider themeChangeProvider = DarkThemeProvider();
NotificationProvider notificationProvider = NotificationProvider();

LocaleProvider localeProvider = LocaleProvider();
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
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  await HiveService.init();

  await TransactionLocalDataSourceImpl.instance.getTransactions();
  await CategoryDB.instance.initializeCategories();

  // Clean Architecture Setup
  final localDataSource = TransactionLocalDataSourceImpl();
  final repository =
      TransactionRepositoryImpl(localDataSource: localDataSource);

  final budgetRepository = BudgetRepositoryImpl();
  final saveBudgetUseCase = SaveMonthlyBudgetUseCase(budgetRepository);

  final getTransactions = GetTransactions(repository);
  final addTransaction = AddTransaction(repository);
  final deleteTransaction = DeleteTransaction(repository);
  final updateTransaction = UpdateTransaction(repository);
  final totalIncomeUseCase = TotalIncomeUseCase();
  final totalExpenseUseCase = TotalExpenseUseCase();
  final totalBalanceUseCase =
      TotalBalanceUseCase(totalIncomeUseCase, totalExpenseUseCase);
  final groupTransactionsUseCase = GroupTransactionsByDateUseCase();
  final getCurrentMonthBudgetUseCase =
      GetCurrentMonthBudgetUseCase(budgetRepository);

  final calculateThisMonth = CalculateThisMonth();

  final getTopCategoriesUseCase = GetTopCategories();
  final generateInsightsUseCase = GenerateInsightsUseCase();

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
                totalBalanceUseCase: totalBalanceUseCase,
                totalIncomeUseCase: totalIncomeUseCase,
                totalExpenseUseCase: totalExpenseUseCase,
                getTransactionsUseCase: getTransactions,
                addTransactionUseCase: addTransaction,
                deleteTransactionUseCase: deleteTransaction,
                updateTransactionUseCase: updateTransaction,
                groupTransactionsUseCase: groupTransactionsUseCase,
              )),
      ChangeNotifierProxyProvider<TransactionProvider, HomeProvider>(
        create: (_) => HomeProvider(
            getCurrentMonthBudgetUseCase: getCurrentMonthBudgetUseCase,
            generateInsightsUseCase: generateInsightsUseCase,
            getTopCategoriesUseCase: getTopCategoriesUseCase,
            calculateThisMonth: calculateThisMonth,
            totalBalanceUseCase: totalBalanceUseCase,
            totalIncomeUseCase: totalIncomeUseCase,
            totalExpenseUseCase: totalExpenseUseCase),
        update: (context, transactionProvider, homeProvider) {
          homeProvider!.updateTransactions(transactionProvider.transactions);
          return homeProvider;
        },
      ),
      ChangeNotifierProvider(
          create: (_) => AddBudgetProvider(
                saveBudgetUseCase: saveBudgetUseCase,
              )),
      ChangeNotifierProvider(
          create: (_) => BudgetProvider(
                // getBudgetUseCase: getBudgetUseCase,
                getTransactions: getTransactions,
                getBudgetUseCase: getCurrentMonthBudgetUseCase,
              )),
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
      // ChangeNotifierProvider(create: (_) => WealthAnalyticsProvider()),
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
      // final list = await TranscationDB.instance.getalltranscation();
      if (mounted) {
        // Provider.of<HomeProvider>(context, listen: false).updateTransactions(list.map((e) => e.toEntity()).toList());
        // Provider.of<AppState>(context, listen: false).totalBalanceCheck(list);
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
