class TransactionDraft {
  final String type; // 'Expense' or 'Income'
  final double amount;
  final String? merchant;
  final String category;
  final DateTime date;
  final String? paymentMethod; // 'UPI', 'Card', 'NetBanking', 'ATM', 'Bank Transfer', etc.
  final String? referenceId;
  final String sourceHash;
  final double confidence; // 0.0 to 1.0
  final String? rawSender;
  final String? purpose;

  const TransactionDraft({
    required this.type,
    required this.amount,
    this.merchant,
    required this.category,
    required this.date,
    this.paymentMethod,
    this.referenceId,
    required this.sourceHash,
    required this.confidence,
    this.rawSender,
    this.purpose,
  });

  TransactionDraft copyWith({
    String? type,
    double? amount,
    String? merchant,
    String? category,
    DateTime? date,
    String? paymentMethod,
    String? referenceId,
    String? sourceHash,
    double? confidence,
    String? rawSender,
    String? purpose,
  }) {
    return TransactionDraft(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceId: referenceId ?? this.referenceId,
      sourceHash: sourceHash ?? this.sourceHash,
      confidence: confidence ?? this.confidence,
      rawSender: rawSender ?? this.rawSender,
      purpose: purpose ?? this.purpose,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'merchant': merchant,
      'category': category,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'referenceId': referenceId,
      'sourceHash': sourceHash,
      'confidence': confidence,
      'rawSender': rawSender,
      'purpose': purpose,
    };
  }

  factory TransactionDraft.fromMap(Map<String, dynamic> map) {
    return TransactionDraft(
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      merchant: map['merchant'] as String?,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      paymentMethod: map['paymentMethod'] as String?,
      referenceId: map['referenceId'] as String?,
      sourceHash: map['sourceHash'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      rawSender: map['rawSender'] as String?,
      purpose: map['purpose'] as String?,
    );
  }

  @override
  String toString() {
    return 'TransactionDraft(type: $type, amount: $amount, merchant: $merchant, category: $category, date: $date, paymentMethod: $paymentMethod, confidence: $confidence)';
  }
}
