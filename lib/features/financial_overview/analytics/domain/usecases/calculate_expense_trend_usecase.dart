import 'package:intl/intl.dart';
import '../../../../transaction/data/models/transcation_model.dart';

class CalculateExpenseTrendUseCase {
  Map<String, double> call(List<TranscationModel> transactions) {
    Map<String, double> trend = {};
    DateTime now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      DateTime monthStart = DateTime(now.year, now.month - i);
      String monthKey = DateFormat('MMM').format(monthStart);

      double expense = 0;
      for (var t in transactions) {
        if (t.date.year == monthStart.year &&
            t.date.month == monthStart.month &&
            t.type.toLowerCase() == 'expense') {
          expense += t.amount;
        }
      }

      trend[monthKey] = expense;
    }

    return trend;
  }
}
