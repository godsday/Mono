import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'package:mono/models/transcation_model/transcation_model.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/transcation_screen/transcation_screen.dart';

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
    final _db = await Hive.openBox<TranscationModel>('transcation-db');
    _db.put(obj.id, obj);
  }

  @override
  Future<void> addtranscation(TranscationModel obj) async {
    final _db = await Hive.openBox<TranscationModel>('transcation-db');
    await _db.put(obj.id, obj);
  }

  @override
  Future<List<TranscationModel>> getalltranscation() async {
    final _db = await Hive.openBox<TranscationModel>('transcation-db');
    return _db.values.toList();
  }

  @override
  Future<void> deletetranscation(String id) async {
    final _db = await Hive.openBox<TranscationModel>('transcation-db');
    await _db.delete(id);
  }

  @override
  Future<void> cleardatabase() async {
    final _db = await Hive.openBox<TranscationModel>('transcation-db');
    _db.clear();
  }
}
