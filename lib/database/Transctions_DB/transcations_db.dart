import 'package:hive_flutter/adapters.dart';

import 'package:mono/models/transcation_model/transcation_model.dart';

//const TRANSCATION_DB_NAME = 'transcation-db';

abstract class TranscationDbfunctions {
  Future<void> addtranscation(TranscationModel obj);
  Future<List<TranscationModel>> getalltranscation();
  Future<void> deletetranscation(String id);
  Future<void> updatetranscation(TranscationModel obj);
  Future<void> cleardatabase();
}

class TranscationDB implements TranscationDbfunctions {
  TranscationDB._internal();
  static TranscationDB instance = TranscationDB._internal();
  factory TranscationDB() {
    return instance;
  }

  @override
  Future<void> updatetranscation(TranscationModel obj) async {
    final db = await Hive.openBox<TranscationModel>('transcation-db');
    db.put(obj.id, obj);
  }

  @override
  Future<void> addtranscation(TranscationModel obj) async {
    final db = await Hive.openBox<TranscationModel>('transcation-db');
    await db.put(obj.id, obj);
  }

  @override
  Future<List<TranscationModel>> getalltranscation() async {
    final db = await Hive.openBox<TranscationModel>('transcation-db');
    return db.values.toList();
  }

  @override
  Future<void> deletetranscation(String id) async {
    final db = await Hive.openBox<TranscationModel>('transcation-db');
    await db.delete(id);
  }

  @override
  Future<void> cleardatabase() async {
    final db = await Hive.openBox<TranscationModel>('transcation-db');
    db.clear();
  }
}
