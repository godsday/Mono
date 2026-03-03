import 'package:intl/intl.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';

class GroupTransactionsByDateUseCase {
  Map<String, List<TranscationModel>> call(
      List<TranscationModel> transactions) {
    Map<String, List<TranscationModel>> groupedTransactions = {};
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateFormat displayFormat = DateFormat('MMM d, yyyy');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    for (var transaction in transactions) {
      String dateKey = dateFormat.format(transaction.date);
      DateTime date = dateFormat.parse(dateKey);
      String dateDisplay = displayFormat.format(date);
      final transactionDate = DateTime(date.year, date.month, date.day);

      String dayLabel = '';
      if (transactionDate.isAtSameMomentAs(today)) {
        dayLabel = 'Today';
      } else if (transactionDate.isAtSameMomentAs(yesterday)) {
        dayLabel = 'Yesterday';
      }

      String finalKey =
          dayLabel.isNotEmpty ? ('$dayLabel $dateDisplay') : dateDisplay;

      if (!groupedTransactions.containsKey(finalKey)) {
        groupedTransactions[finalKey] = [];
      }
      groupedTransactions[finalKey]!.add(transaction);
    }

    return groupedTransactions;
  }
}
