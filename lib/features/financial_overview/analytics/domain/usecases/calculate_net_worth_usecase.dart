import '../../../../transaction/data/models/transcation_model.dart';
import '../../../asset/domain/entities/asset_entity.dart';
import '../entities/net_worth_data.dart';

class CalculateNetWorthUseCase {
  NetWorthData call({
    required List<AssetEntity> assets,
    required List<TranscationModel> transactions,
  }) {
    double totalAssets = 0;
    double totalLiabilities =
        0; // Assume liability if asset type is 'liability' or 'debt'

    for (var asset in assets) {
      if (asset.type.toLowerCase() == 'liability' ||
          asset.type.toLowerCase() == 'debt') {
        totalLiabilities += asset.currentValue;
      } else {
        totalAssets += asset.currentValue;
      }
    }

    double currentNetWorth = totalAssets - totalLiabilities;

    // Calculate history based on income/expenses over last 6 months
    // We start from current net worth, and go backwards.
    // Last month's net worth = Current - (Current Month Income - Current Month Expense)
    Map<DateTime, double> history = {};
    DateTime now = DateTime.now();

    double runningNetWorth = currentNetWorth;

    for (int i = 0; i < 6; i++) {
      DateTime monthStart = DateTime(now.year, now.month - i);
      if (i == 0) {
        history[monthStart] = runningNetWorth;
      } else {
        // Calculate previous month's net change to undo it
        // Wait, to get the net worth at the start of month 'i', we need to subtract the net cash flow of month 'i' from the end-of-month net worth.
        // Actually, an easier approximation: just take the cashflow of each month.
        // Let's just calculate historical net worth from the start of the app if possible.
        // Or working backwards: NetWorth(prev_month) = NetWorth(curr) - NetCashFlow(curr)
        DateTime nextMonthStart = DateTime(now.year, now.month - i + 1);

        double monthIncome = 0;
        double monthExpense = 0;

        for (var t in transactions) {
          if (t.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(nextMonthStart)) {
            if (t.type.toLowerCase() == 'income') {
              monthIncome += t.amount;
            } else if (t.type.toLowerCase() == 'expense') {
              monthExpense += t.amount;
            }
          }
        }

        double netCashFlow = monthIncome - monthExpense;
        runningNetWorth -= netCashFlow;
        history[monthStart] = runningNetWorth;
      }
    }

    // Sort history chronologically
    var sortedEntries = history.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    Map<DateTime, double> sortedHistory = Map.fromEntries(sortedEntries);

    // Calculate growth percentage from 6 months ago to now
    double oldestNetWorth = sortedEntries.first.value;
    double growth = 0;
    if (oldestNetWorth != 0) {
      growth =
          ((currentNetWorth - oldestNetWorth) / oldestNetWorth.abs()) * 100;
    } else if (currentNetWorth > 0) {
      growth = 100; // arbitrary high number if starting from 0
    }

    return NetWorthData(
      currentNetWorth: currentNetWorth,
      historyLast6Months: sortedHistory,
      growthPercentage: growth,
    );
  }
}
