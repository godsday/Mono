import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'package:mono/models/transcation_model/transcation_model.dart';
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

  ValueNotifier<List<TranscationModel>> transcationNotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> incomelistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> expenselistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> todaylistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> yesterdaylistnotifier =
      ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> customlistnotifier = ValueNotifier([]);

  @override
  Future<void> addtranscation(TranscationModel obj) async {
    final _db = await Hive.openBox<TranscationModel>('transcation-db');
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getalltranscation();
    totalBalanceCheck(_list);
    _list.sort((first, second) => second.date.compareTo(first.date));
    yesterdaylistnotifier.value.clear();
    transcationNotifier.value.clear();
    incomelistnotifier.value.clear();
    expenselistnotifier.value.clear();
    todaylistnotifier.value.clear();

    transcationNotifier.value.addAll(_list);

    final _today = DateFormat().add_yMMMMd().format(DateTime.now());
    final _yesterday = DateFormat()
        .add_yMMMMd()
        .format(DateTime.now().subtract(const Duration(days: 1)));

    Future.forEach(_list, (TranscationModel transcationlist) {
      final _dates = DateFormat().add_yMMMMd().format(transcationlist.date);
      if (transcationlist.type == 'Expense') {
        expenselistnotifier.value.add(transcationlist);
      } else {
        incomelistnotifier.value.add(transcationlist);
      }

      if (_dates == _today) {
        todaylistnotifier.value.add(transcationlist);
      } else if (_dates == _yesterday) {
        yesterdaylistnotifier.value.add(transcationlist);
      }
    });

    // yesterdaylistnotifier.notifyListeners();
    // transcationNotifier.notifyListeners();
    // expenselistnotifier.notifyListeners();
    // incomelistnotifier.notifyListeners();
    // todaylistnotifier.notifyListeners();
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

  custompick(DateTime start, DateTime end) {
    customlistnotifier.value.clear();

    for (TranscationModel data in transcationNotifier.value) {
      if ((data.date.day >= start.day) &&
          (data.date.day <= end.day) &&
          (data.date.month >= start.month) &&
          (data.date.month >= end.month) &&
          (data.date.year <= start.year) &&
          (data.date.year >= end.year)) {
        customlistnotifier.value.add(data);
      }
    }
    // customlistnotifier.notifyListeners();
  }

  @override
  Future<void> cleardatabase() async {
    final _db = await Hive.openBox<TranscationModel>('transcation-db');
    _db.clear();
  }
}
