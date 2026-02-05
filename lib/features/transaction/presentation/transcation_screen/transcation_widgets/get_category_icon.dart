import 'package:flutter/material.dart';

class GetCategoryIcon extends StatelessWidget {
  const GetCategoryIcon({
    super.key,
    required this.category,
    required this.type,
  });

  final String category;
  final String type;

  @override
  Widget build(BuildContext context) {
    // Define icon mappings based on category
    switch (category.toLowerCase()) {
      case 'salary':
        return const Icon(Icons.account_balance_wallet, color: Colors.blue);
      case 'shopping':
        return const Icon(Icons.shopping_cart, color: Colors.purple);
      case 'food':
        return const Icon(Icons.fastfood, color: Colors.orange);
      case 'travel':
        return const Icon(Icons.flight, color: Colors.blueAccent);
      case 'medical':
        return const Icon(Icons.local_hospital, color: Colors.red);
      case 'utilities':
        return const Icon(Icons.lightbulb, color: Colors.yellow);
      case 'education':
      case 'educations':
        return const Icon(Icons.school, color: Colors.green);
      case 'entertainment':
        return const Icon(Icons.movie, color: Colors.pink);
      case 'insurance':
        return const Icon(Icons.security, color: Colors.indigo);
      case 'rental':
        return const Icon(Icons.home, color: Colors.brown);
      case 'gift':
        return const Icon(Icons.card_giftcard, color: Colors.purpleAccent);
      case 'freelance':
        return const Icon(Icons.work, color: Colors.teal);
      case 'commission':
        return const Icon(Icons.business, color: Colors.deepOrange);

      case 'investments':
        return const Icon(Icons.trending_up, color: Colors.greenAccent);
      case 'credit':
        return const Icon(Icons.credit_card, color: Colors.blueGrey);
      case 'debit':
        return const Icon(Icons.account_balance, color: Colors.redAccent);
      case 'other':
        return Icon(
          type == 'Income' ? Icons.attach_money : Icons.money_off,
          color: type == 'Income' ? Colors.green : Colors.red,
        );
      default:
        return Icon(
          type == 'Income' ? Icons.arrow_downward : Icons.arrow_upward,
          color: type == 'Income' ? Colors.green : Colors.red,
        );
    }
  }
}
