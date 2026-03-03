import 'package:intl/intl.dart';
import '../../../../transaction/data/models/transcation_model.dart';
import '../../../budget/domain/entities/budget_entity.dart';
import '../entities/budget_discipline_data.dart';

class CalculateBudgetDisciplineUseCase {
  BudgetDisciplineData call(
      List<BudgetEntity> budgets, List<TranscationModel> transactions) {
    Map<String, Map<String, double>> last6MonthsData = {};
    int monthsUnderBudget = 0;

    DateTime now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      DateTime monthStart = DateTime(now.year, now.month - i);
      String monthKey = DateFormat('MMM yyyy').format(monthStart);

      // Find budget for this month
      BudgetEntity? budgetForMonth;
      for (var b in budgets) {
        if (b.month == monthKey || (b.month.isEmpty && i == 0)) {
          // Sometimes budget for current month might not have month set properly, check if i == 0 and take latest
          budgetForMonth = b;
          break;
        }
      }

      double totalBudget = budgetForMonth?.totalBudget ?? 0;

      // Calculate actual expenses for this month
      double actualExpense = 0;
      for (var t in transactions) {
        if (t.date.year == monthStart.year &&
            t.date.month == monthStart.month &&
            t.type.toLowerCase() == 'expense') {
          actualExpense += t.amount;
        }
      }

      last6MonthsData[monthKey] = {
        'budget': totalBudget,
        'actual': actualExpense,
      };

      if (totalBudget > 0 && actualExpense <= totalBudget) {
        monthsUnderBudget++;
      }
    }

    double disciplinePercentage = (monthsUnderBudget / 6) * 100;

    return BudgetDisciplineData(
      last6MonthsData: last6MonthsData,
      monthsUnderBudget: monthsUnderBudget,
      budgetDisciplinePercentage: disciplinePercentage,
    );
  }
}
