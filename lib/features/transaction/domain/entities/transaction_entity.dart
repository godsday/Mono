class TransactionEntity {
  final String id;
  final String type; // 'Income' or 'Expense' - Consider using an Enum later
  final double amount;
  final DateTime date;
  final String category;
  final String? purpose;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.category,
    this.purpose,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'purpose': purpose,
    };
  }

  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      purpose: map['purpose'],
    );
  }
}
