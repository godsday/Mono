import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/features/financial_overview/budget/data/models/budget_model.dart';
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

    final transactionsList =
        transactionsBox.values.map((e) => e.toEntity().toMap()).toList();
    final budgetsList =
        budgetsBox.values.map((e) => e.toEntity().toMap()).toList();

    return {
      "transactions": transactionsList,
      "budgets": budgetsList,
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

  Future<void> exportData() async {
    try {
      final jsonString = await generateBackupJson();

      final file = await saveBackupFile(jsonString);
      final params = ShareParams(
        text: 'Here is your Mono backup file.',
        subject: 'Mono Backup',
        files: [XFile(file.path)],
      );
      await SharePlus.instance.share(params);
    } catch (e) {
      print("Export failed: $e");
    }
  }
}
