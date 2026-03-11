import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mono/features/financial_overview/budget/data/repositories/budget_repository_impl.dart';
import 'package:mono/features/financial_overview/budget/domain/repositories/budget_repository.dart';
import 'package:mono/features/financial_overview/budget/domain/usecases/get_current_month_budget_usecase.dart';
import 'package:mono/features/financial_overview/budget/domain/usecases/save_monthly_budget_usecase.dart';
import 'package:mono/features/transaction/data/datasources/transaction_local_data_source.dart';
import 'package:mono/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:mono/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:mono/features/transaction/domain/usecases/add_transaction.dart';
import 'package:mono/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:mono/features/transaction/domain/usecases/get_transactions.dart';
import 'package:mono/features/transaction/domain/usecases/update_transaction.dart';
import 'package:mono/features/transaction/domain/usecases/calcuate_total_income.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_expense.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_balance.dart';
import 'package:mono/features/transaction/domain/usecases/group_transactions_by_date.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_this_month.dart';
import 'package:mono/features/home/domain/usecase/get_top_categories.dart';
import 'package:mono/features/home/domain/usecase/smart_insight_usecase.dart';
import 'package:mono/features/financial_overview/asset/data/repositories/asset_repository_impl.dart';
import 'package:mono/features/financial_overview/asset/domain/repositories/asset_repository.dart';
import 'package:mono/features/financial_overview/asset/domain/usecases/add_asset_usecase.dart';
import 'package:mono/features/financial_overview/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:mono/features/financial_overview/asset/domain/usecases/get_assets_usecase.dart';
import 'package:mono/features/financial_overview/goals/data/repositories/goal_repository_impl.dart';
import 'package:mono/features/financial_overview/goals/domain/repositories/goal_repository.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/add_goal_usecase.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/get_goals_usecase.dart';
import 'package:mono/features/financial_overview/goals/domain/usecases/update_goal_progress_usecase.dart';
import 'package:mono/features/app_settings/data/datasources/app_settings_local_data_source.dart';
import 'package:mono/features/app_settings/data/repositories/app_settings_repository_impl.dart';
import 'package:mono/features/app_settings/domain/repositories/app_settings_repository.dart';
import 'package:mono/features/app_settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:mono/features/app_settings/domain/usecases/update_language_usecase.dart';
import 'package:mono/features/app_settings/domain/usecases/update_currency_usecase.dart';
import 'package:mono/providers/theme_provider.dart';
import 'package:mono/providers/notification_provider.dart';
import 'package:mono/providers/locale_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Core
  sl.registerLazySingleton(() => DarkThemeProvider());
  sl.registerLazySingleton(() => NotificationProvider());
  sl.registerLazySingleton(() => LocaleProvider());

  // Features - Transactions
  // Use Cases
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => TotalIncomeUseCase());
  sl.registerLazySingleton(() => TotalExpenseUseCase());
  sl.registerLazySingleton(() => TotalBalanceUseCase(sl(), sl()));
  sl.registerLazySingleton(() => GroupTransactionsByDateUseCase());
  sl.registerLazySingleton(() => CalculateThisMonth());

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(),
  );

  // Features - Budget
  // Use Cases
  sl.registerLazySingleton(() => SaveMonthlyBudgetUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentMonthBudgetUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(),
  );

  // Features - Home/Insights
  // Use Cases
  sl.registerLazySingleton(() => GetTopCategories());
  sl.registerLazySingleton(() => GenerateInsightsUseCase());

  // Features - Assets
  // Use Cases
  sl.registerLazySingleton(() => GetAssetsUseCase(sl()));
  sl.registerLazySingleton(() => AddAssetUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAssetUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(),
  );

  // Features - Goals
  // Use Cases
  sl.registerLazySingleton(() => GetGoalsUseCase(sl()));
  sl.registerLazySingleton(() => AddGoalUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGoalProgressUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<GoalRepository>(
    () => GoalRepositoryImpl(),
  );

  // Features - App Settings
  // Use Cases
  sl.registerLazySingleton(() => GetAppSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLanguageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCurrencyUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AppSettingsRepository>(
    () => AppSettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AppSettingsLocalDataSource>(
    () => AppSettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
