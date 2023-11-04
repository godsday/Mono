// import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:mono/models/category_model/category_model.dart';

// // ignore: constant_identifier_names
// const CATEGORY_DB_NAME ='catergory_database';


// abstract class CategoryDbFuctions{

//  Future <List<CategoryModel>>getCatergories();
 
//   Future<void>insertCategory(CategoryModel value);  
// }
// class CategoryDB extends CategoryDbFuctions{
//   ValueNotifier<List<CategoryModel>> incomecategoriesList =ValueNotifier([]);
//     ValueNotifier<List<CategoryModel>> expensecategoriesList =ValueNotifier([]);


//   @override
//   Future <List<CategoryModel>> getCatergories()async {

// final _categoryDB=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
// return _categoryDB.values.toList();

//   }

//   @override
//   Future<void> insertCategory(CategoryModel value)async {

//     final _categoryDB=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
//   await _categoryDB.add(value);
//   refreshUI();
  
//   }
  

//  Future refreshUI()async{
//    final _allCategories = await getCatergories();
//    incomecategoriesList.value.clear();
//    expensecategoriesList.value.clear();


//    await Future.forEach(_allCategories, (CategoryModel category) {

//      if(category.type==CategoryType.expense){
//        incomecategoriesList.value.add(category);
//      }else{
//        expensecategoriesList.value.add(category);
//      }

//    }
//    );
//    incomecategoriesList.notifyListeners();
//    expensecategoriesList.notifyListeners();

//   }
// }