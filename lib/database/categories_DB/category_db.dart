import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mono/models/category_model/category_model.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'category_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String id);
}

class CategoryDB extends CategoryDbFunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoriesList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoriesList = ValueNotifier([]);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<void> deleteCategory(String id) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(id);
    refreshUI();
  }

  Future refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoriesList.value.clear();
    expenseCategoriesList.value.clear();

    await Future.forEach(_allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoriesList.value.add(category);
      } else {
        expenseCategoriesList.value.add(category);
      }
    });
    incomeCategoriesList.notifyListeners();
    expenseCategoriesList.notifyListeners();
  }

  Future<void> initializeCategories() async {
    // Initialize with default categories if database is empty
    final categories = await getCategories();
    if (categories.isEmpty) {
      // Default income categories
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_salary",
          type: CategoryType.income,
          name: "Salary"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_gift",
          type: CategoryType.income,
          name: "Gift"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_rental",
          type: CategoryType.income,
          name: "Rental"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_credit",
          type: CategoryType.income,
          name: "Credit"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_other_income",
          type: CategoryType.income,
          name: "Other"));

      // Default expense categories
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_shopping",
          type: CategoryType.expense,
          name: "Shopping"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_travel",
          type: CategoryType.expense,
          name: "Travel"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_food",
          type: CategoryType.expense,
          name: "Food"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_medical",
          type: CategoryType.expense,
          name: "Medical"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_insurance",
          type: CategoryType.expense,
          name: "Insurance"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_utilities",
          type: CategoryType.expense,
          name: "Utilities"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_education",
          type: CategoryType.expense,
          name: "Education"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_entertainment",
          type: CategoryType.expense,
          name: "Entertainment"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_debit",
          type: CategoryType.expense,
          name: "Debit"));
      await insertCategory(CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + "_other_expense",
          type: CategoryType.expense,
          name: "Other"));
    }
  }
}