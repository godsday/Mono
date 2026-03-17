import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';
import 'package:mono/features/financial_overview/budget/data/models/budget_model.dart';
import 'package:mono/features/financial_overview/budget/domain/entities/budget_entity.dart';
import 'package:mono/features/add_screen/domain/entities/category_entity.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static final BackupService instance = BackupService._();
  BackupService._();

  Future<Map<String, dynamic>> collectAppData() async {
    final transactionsBox =
        Hive.box<TranscationModel>(AppStrings.transactionBoxName);
    final budgetsBox = Hive.box<BudgetModel>(AppStrings.budgetBoxName);
    final budgetCategoriesBox =
        Hive.box<BudgetCategoryModel>(AppStrings.budgetCategoryBoxName);

    final categoriesBox = Hive.box<CategoryModel>(AppStrings.categoryBoxName);

    final transactionsList =
        transactionsBox.values.map((e) => e.toEntity().toMap()).toList();
    final budgetsList =
        budgetsBox.values.map((e) => e.toEntity().toMap()).toList();
    final budgetCategoriesList =
        budgetCategoriesBox.values.map((e) => e.toEntity().toMap()).toList();

    final categoriesList =
        categoriesBox.values.map((e) => e.toEntity().toMap()).toList();

    return {
      "transactions": transactionsList,
      "categories": categoriesList,
      "budgets": budgetsList,
      "budgetCategories": budgetCategoriesList,
      "exported_at": DateTime.now().toIso8601String(),
      "app_version": 1
    };
  }

  Future<String> generateBackupJson() async {
    final data = await collectAppData();
    return jsonEncode(data);
  }

  Future<File> saveBackupFile(String jsonString) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
        "${directory.path}/mono_backup_${DateTime.now().millisecondsSinceEpoch}.json");

    return await file.writeAsString(jsonString);
  }

  Future<bool> exportData() async {
    try {
      final transactionsBox =
          Hive.box<TranscationModel>(AppStrings.transactionBoxName);
      if (transactionsBox.isEmpty) {
        return false;
      }
      final jsonString = await generateBackupJson();

      final file = await saveBackupFile(jsonString);
      final params = ShareParams(
        text: 'Here is your Mono backup file.',
        subject: 'Mono Backup',
        files: [XFile(file.path)],
      );
      await SharePlus.instance.share(params);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> importBackup() async {
    try {
      // 1️⃣ Pick backup file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) return false;

      final file = File(result.files.single.path!);

      // 2️⃣ Read file
      final jsonString = await file.readAsString();

      // 3️⃣ Decode JSON
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      // 4️⃣ Get Hive boxes with correct types
      final Box<TranscationModel> transactionsBox =
          Hive.box<TranscationModel>(AppStrings.transactionBoxName);

      final Box<BudgetModel> budgetsBox =
          Hive.box<BudgetModel>(AppStrings.budgetBoxName);

      final Box<BudgetCategoryModel> budgetCategoriesBox =
          Hive.box<BudgetCategoryModel>(AppStrings.budgetCategoryBoxName);

      final Box<CategoryModel> categoriesBox =
          Hive.box<CategoryModel>(AppStrings.categoryBoxName);

      // 5️⃣ OPTIONAL: Clear existing data
      await transactionsBox.clear();
      await budgetsBox.clear();
      await budgetCategoriesBox.clear();
      await categoriesBox.clear();

      // 6️⃣ Restore Transactions
      final List<dynamic> transactions = backupData["transactions"] as List;
      for (var item in transactions) {
        final model = TranscationModel.fromMap(item);
        await transactionsBox.put(model.id, model);
      }

      // 7️⃣ Restore Budgets
      final List<dynamic> budgets = backupData["budgets"] as List;
      for (var item in budgets) {
        final entity = BudgetEntity.fromMap(item);
        final model = BudgetModel.fromEntity(entity);
        await budgetsBox.put('current_budget', model);
      }

      // 8️⃣ Restore Categories
      final List<dynamic> budgetCategories =
          backupData["budgetCategories"] as List;
      for (var item in budgetCategories) {
        final entity = BudgetCategoryEntity.fromMap(item);
        final model = BudgetCategoryModel.fromEntity(entity);
        await budgetCategoriesBox.put(model.id, model);
      }

      // 9️⃣ Restore Categories
      final List<dynamic> categories = backupData["categories"] as List;
      for (var item in categories) {
        final entity = CategoryEntity.fromMap(item);
        final model = CategoryModel.fromEntity(entity);
        await categoriesBox.put(model.id, model);
      }

      debugPrint("Import successful ✅");
      return true;
    } catch (e) {
      debugPrint("Import failed ❌: $e");
      return false;
    }
  }
}
