import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/update_transaction.dart';

class TransactionProvider with ChangeNotifier {
  final GetTransactions getTransactionsUseCase;
  final AddTransaction addTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;
  final UpdateTransaction updateTransactionUseCase;

  List<TransactionEntity> _transactions = [];
  bool _isLoading = false;
  String? _error;

  TransactionProvider({
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.updateTransactionUseCase,
  });

  List<TransactionEntity> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await getTransactionsUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      await addTransactionUseCase(transaction);
      // Optimistic update or reload
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await deleteTransactionUseCase(id);
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      await updateTransactionUseCase(transaction);
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
