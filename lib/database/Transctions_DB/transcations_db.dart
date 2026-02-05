// import 'package:hive_flutter/adapters.dart';

// import 'package:mono/features/transaction/data/models/transcation_model.dart';

// //const TRANSCATION_DB_NAME = 'transcation-db';

// abstract class TranscationDbfunctions {
//   Future<void> addtranscation(TranscationModel obj);
//   Future<List<TranscationModel>> getalltranscation();
//   Future<void> deletetranscation(String id);
//   Future<void> updatetranscation(TranscationModel obj);
//   Future<void> cleardatabase();
// }

// class TranscationDB implements TranscationDbfunctions {
//   TranscationDB._internal();
//   static TranscationDB instance = TranscationDB._internal();
//   factory TranscationDB() {
//     return instance;
//   }
//     static const String boxName = 'transcation-db';

//    Future<Box<TranscationModel>> _openBox() async {
//     if (Hive.isBoxOpen(boxName)) {
//       return Hive.box<TranscationModel>(boxName);
//     }
//     return await Hive.openBox<TranscationModel>(boxName);
//   }

//   @override
//   Future<void> updatetranscation(TranscationModel obj) async {
//      final box = await _openBox();
//     await box.put(obj.id, obj);
//   }

//   @override
//   Future<void> addtranscation(TranscationModel obj) async {
//     final db = await Hive.openBox<TranscationModel>('transcation-db');
//     await db.put(obj.id, obj);
//   }

//   @override
//   Future<List<TranscationModel>> getTransactions() async {
//       final box = await _openBox();
//     return box.values.toList();
//   }

//   @override
//   Future<void> deleteTransaction(String id) async {
//     final box = await _openBox();
//     await box.delete(id);
//   }

//   @override
//   Future<void> clearTransactions() async {
//      final box = await _openBox();
//     await box.clear();
//   }
// }
