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
    if (categoryBox.isEmpty) {
      await initializeCategories();
    }
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
    if (categoryBox.isEmpty) {
      final Map<String, CategoryModel> initialCategories = {};
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Default income categories
      initialCategories["${now}_salary"] = CategoryModel(
          id: "${now}_salary", type: CategoryType.income, name: "Salary");
      initialCategories["${now}_gift"] = CategoryModel(
          id: "${now}_gift", type: CategoryType.income, name: "Gift");
      initialCategories["${now}_rental"] = CategoryModel(
          id: "${now}_rental", type: CategoryType.income, name: "Rental");
      initialCategories["${now}_credit"] = CategoryModel(
          id: "${now}_credit", type: CategoryType.income, name: "Credit");
      initialCategories["${now}_other_income"] = CategoryModel(
          id: "${now}_other_income", type: CategoryType.income, name: "Other");

      // Default expense categories
      initialCategories["${now}_shopping"] = CategoryModel(
          id: "${now}_shopping", type: CategoryType.expense, name: "Shopping");
      initialCategories["${now}_travel"] = CategoryModel(
          id: "${now}_travel", type: CategoryType.expense, name: "Travel");
      initialCategories["${now}_food"] = CategoryModel(
          id: "${now}_food", type: CategoryType.expense, name: "Food");
      initialCategories["${now}_medical"] = CategoryModel(
          id: "${now}_medical", type: CategoryType.expense, name: "Medical");
      initialCategories["${now}_insurance"] = CategoryModel(
          id: "${now}_insurance", type: CategoryType.expense, name: "Insurance");
      initialCategories["${now}_utilities"] = CategoryModel(
          id: "${now}_utilities", type: CategoryType.expense, name: "Utilities");
      initialCategories["${now}_education"] = CategoryModel(
          id: "${now}_education", type: CategoryType.expense, name: "Education");
      initialCategories["${now}_entertainment"] = CategoryModel(
          id: "${now}_entertainment", type: CategoryType.expense, name: "Entertainment");
      initialCategories["${now}_debit"] = CategoryModel(
          id: "${now}_debit", type: CategoryType.expense, name: "Debit");
      initialCategories["${now}_other_expense"] = CategoryModel(
          id: "${now}_other_expense", type: CategoryType.expense, name: "Other");

      await categoryBox.putAll(initialCategories);
      await refreshUI();
    }
  }
}
