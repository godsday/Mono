import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';
import 'package:mono/models/top_category_model.dart';

abstract class HomeRepository {
  double calculateTotalBalance(List<TransactionEntity> transactions);
  double calculateTotalIncome(List<TransactionEntity> transactions);
  double calculateTotalExpense(List<TransactionEntity> transactions);
  List<TransactionEntity> filterLast31Days(
      List<TransactionEntity> transactions);
  String getSpendingCycleLabel();
  double getThisMonthIncome(List<TransactionEntity> transactions);
  double getThisMonthExpense(List<TransactionEntity> transactions);
  double getThisMonthBalance(List<TransactionEntity> transactions);
  List<TopCategory> getTopCategories(
      List<TransactionEntity> transactions, String type);
}
