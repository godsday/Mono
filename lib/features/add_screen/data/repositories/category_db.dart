import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';

// ignore: constant_identifier_names

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

  final categoryBox = Hive.box<CategoryModel>(AppStrings.categoryBoxName);

  @override
  Future<List<CategoryModel>> getCategories() async {
    return categoryBox.values.toList();
  }

  @override
  Future<void> insertCategory(CategoryModel value) async {
    await categoryBox.put(value.id, value);
    refreshUI();
  }

  @override
  Future<void> deleteCategory(String id) async {
    await categoryBox.delete(id);
    refreshUI();
  }

  Future refreshUI() async {
    final allCategories = await getCategories();
    final List<CategoryModel> income = [];
    final List<CategoryModel> expense = [];

    for (var category in allCategories) {
      if (category.type == CategoryType.income) {
        income.add(category);
      } else {
        expense.add(category);
      }
    }
    incomeCategoriesList.value = income;
    expenseCategoriesList.value = expense;
  }

  Future<void> initializeCategories() async {
    // Initialize with default categories if database is empty
    final categories = await getCategories();
    if (categories.isEmpty) {
      // Default income categories
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_salary",
          type: CategoryType.income,
          name: "Salary"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_gift",
          type: CategoryType.income,
          name: "Gift"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_rental",
          type: CategoryType.income,
          name: "Rental"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_credit",
          type: CategoryType.income,
          name: "Credit"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_other_income",
          type: CategoryType.income,
          name: "Other"));

      // Default expense categories
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_shopping",
          type: CategoryType.expense,
          name: "Shopping"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_travel",
          type: CategoryType.expense,
          name: "Travel"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_food",
          type: CategoryType.expense,
          name: "Food"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_medical",
          type: CategoryType.expense,
          name: "Medical"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_insurance",
          type: CategoryType.expense,
          name: "Insurance"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_utilities",
          type: CategoryType.expense,
          name: "Utilities"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_education",
          type: CategoryType.expense,
          name: "Education"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_entertainment",
          type: CategoryType.expense,
          name: "Entertainment"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_debit",
          type: CategoryType.expense,
          name: "Debit"));
      await insertCategory(CategoryModel(
          id: "${DateTime.now().millisecondsSinceEpoch}_other_expense",
          type: CategoryType.expense,
          name: "Other"));
    }
  }
}
