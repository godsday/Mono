import 'dart:math';
import '../../../../transaction/data/models/transcation_model.dart';
import '../entities/volatility_data.dart';

class CalculateVolatilityUseCase {
  VolatilityData call(List<TranscationModel> transactions) {
    DateTime now = DateTime.now();
    List<double> monthlyExpenses = [];

    // Calculate expenses for last 6 months
    for (int i = 0; i < 6; i++) {
      DateTime monthStart = DateTime(now.year, now.month - i);
      double currentMonthExpense = 0;
      for (var t in transactions) {
        if (t.date.year == monthStart.year &&
            t.date.month == monthStart.month &&
            t.type.toLowerCase() == 'expense') {
          currentMonthExpense += t.amount;
        }
      }
      monthlyExpenses.add(currentMonthExpense);
    }

    if (monthlyExpenses.isEmpty || monthlyExpenses.every((e) => e == 0)) {
      return VolatilityData(
          standardDeviation: 0, classification: VolatilityClassification.low);
    }

    double mean =
        monthlyExpenses.reduce((a, b) => a + b) / monthlyExpenses.length;
    double sumOfSquaredDiffs = monthlyExpenses
        .map((exp) => pow(exp - mean, 2))
        .reduce((a, b) => a + b)
        .toDouble();
    double variance = sumOfSquaredDiffs / monthlyExpenses.length;
    double standardDeviation = sqrt(variance);

    // Classify
    VolatilityClassification classification = VolatilityClassification.medium;
    if (mean == 0) {
      classification = VolatilityClassification.low;
    } else {
      double cv = standardDeviation / mean; // Coefficient of Variation
      if (cv < 0.15) {
        classification = VolatilityClassification.low;
      } else if (cv < 0.30) {
        classification = VolatilityClassification.medium;
      } else {
        classification = VolatilityClassification.high;
      }
    }

    return VolatilityData(
      standardDeviation: standardDeviation,
      classification: classification,
    );
  }
}
