class ProjectFutureExpenseUseCase {
  double call(Map<String, double> last6MonthsTrend) {
    if (last6MonthsTrend.isEmpty) return 0;

    List<double> expenses = last6MonthsTrend.values.toList();

    // Reverse to get most recent first
    expenses = expenses.reversed.toList();

    // Average of last 3 months
    int count = 0;
    double sum = 0;
    for (int i = 0; i < 3 && i < expenses.length; i++) {
      sum += expenses[i];
      count++;
    }

    if (count == 0) return 0;
    return sum / count;
  }
}
