import 'dart:convert';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/features/financial_overview/asset/data/models/asset_model.dart';
import 'package:mono/features/financial_overview/budget/data/models/budget_model.dart';
import 'package:mono/features/financial_overview/goals/data/models/goal_model.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/models/category_model/category_model.dart';

class HiveService {
  static const String _keyKey = 'hive_encryption_key';
  static final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage();

  // Call this once, e.g., in main()
  static Future<void> init() async {
    await Hive.initFlutter();

    // Obtain the encryption key (create if not exists)
    final encryptionKey = await _getEncryptionKey();

    if (!Hive.isAdapterRegistered(TranscationModelAdapter().typeId)) {
      Hive.registerAdapter(TranscationModelAdapter());
    }

    if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }

    if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
      Hive.registerAdapter(CategoryTypeAdapter());
    }

    // Financial Overview Adapters
    if (!Hive.isAdapterRegistered(BudgetModelAdapter().typeId)) {
      Hive.registerAdapter(BudgetModelAdapter());
    }
    if (!Hive.isAdapterRegistered(BudgetCategoryModelAdapter().typeId)) {
      Hive.registerAdapter(BudgetCategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(AssetModelAdapter().typeId)) {
      Hive.registerAdapter(AssetModelAdapter());
    }
    if (!Hive.isAdapterRegistered(GoalModelAdapter().typeId)) {
      Hive.registerAdapter(GoalModelAdapter());
    }

    Future<Box<T>> isOpenBox<T>(String boxName) async {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<T>(boxName);
      }
      return await Hive.openBox<T>(
        boxName,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }

    await isOpenBox<TranscationModel>(AppStrings.transactionBoxName);

    await isOpenBox<CategoryModel>(AppStrings.categoryBoxName);
    await isOpenBox<BudgetModel>(
      AppStrings.budgetBoxName,
    );
    await isOpenBox<AssetModel>(
      AppStrings.assetsBoxName,
    );
    await isOpenBox<GoalModel>(
      AppStrings.goalsBoxName,
    );
  }

  static Future<Uint8List> _getEncryptionKey() async {
    final existingKey = await _secureStorage.read(key: _keyKey);
    if (existingKey != null) {
      return base64Url.decode(existingKey);
    }

    // No key exists – generate a new one
    final newKey = Hive.generateSecureKey(); // or your own generation
    await _secureStorage.write(key: _keyKey, value: base64Url.encode(newKey));
    return Uint8List.fromList(newKey);
  }
}
