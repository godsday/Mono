import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/models/top_category_model.dart';

class GetTopCategories {
  List<TopCategory> getTopCategories(
      List<TranscationModel> transactions, String type) {
    Map<String, double> categoryTotals = <String, double>{};
    double totalTypeAmount = 0;

    // Filter transactions by type and calculate totals
    var transactionsOfType = transactions.where((t) => t.type == type).toList();
    for (var t in transactionsOfType) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
      totalTypeAmount += t.amount;
    }
    // print("${categoryTotals.entries} ----  ${totalTypeAmount}");
    // Convert to TopCategory list
    List<TopCategory> topCategories = categoryTotals.entries.map((entry) {
      return TopCategory(
          name: entry.key,
          amount: entry.value,
          percentage:
              totalTypeAmount > 0 ? (entry.value / totalTypeAmount) * 100 : 0);
    }).toList();

    // Sort by amount descending
    topCategories.sort((a, b) => b.amount.compareTo(a.amount));

    return topCategories.take(2).toList();
  }
}
