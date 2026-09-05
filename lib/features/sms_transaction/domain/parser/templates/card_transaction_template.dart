import '../../entities/transaction_draft.dart';
import '../transaction_template.dart';

import '../utils/amount_extractor.dart';
import '../utils/category_mapper.dart';
import '../utils/merchant_extractor.dart';

class CardTransactionTemplate implements TransactionSmsTemplate {
  @override
  String get templateId => 'card_templates';

  @override
  int get priority => 85;

  static final RegExp _cardKeywords = RegExp(
    r'\b(?:Credit\s*Card|Debit\s*Card|Card\s*(?:no\.?|ending)?\s*(?:xx|x|\*+|-)?\s*\d{3,4}|POS|swipe)\b',
    caseSensitive: false,
  );

  static final RegExp _refPattern = RegExp(
    r'\b(?:auth\s*(?:code|id)?|txn\s*(?:id|no)?|ref(?:\s*no)?)\s*[:#\-]?\s*([a-zA-Z0-9]+)',
    caseSensitive: false,
  );

  @override
  bool canParse(String sender, String body) {
    return _cardKeywords.hasMatch(body);
  }

  @override
  TransactionDraft? parse({
    required String sender,
    required String body,
    required DateTime timestamp,
  }) {
    final amountResult = AmountExtractor.extract(body);
    if (amountResult == null || amountResult.amount <= 0) return null;

    final lower = body.toLowerCase();
    final isCredit = lower.contains('credited') || lower.contains('refund') || lower.contains('cashback');

    final type = isCredit ? 'Income' : 'Expense';
    final merchant = MerchantExtractor.extract(body) ?? (isCredit ? 'Card Refund' : 'Card Payment');

    final refMatch = _refPattern.firstMatch(body);
    final refId = refMatch?.group(1);

    final isCreditCard = lower.contains('credit card');
    final isDebitCard = lower.contains('debit card');
    final paymentMethod = isCreditCard ? 'Credit Card' : (isDebitCard ? 'Debit Card' : 'Card');

    final category = CategoryMapper.mapCategory(
      type: type,
      merchant: merchant,
      fullBody: body,
    );

    final cleanSender = sender.toUpperCase().trim();
    final sourceHash = 'sms_${cleanSender}_${amountResult.amount}_${type}_${timestamp.year}_${timestamp.month}_${timestamp.day}_${refId ?? merchant.toLowerCase().replaceAll(RegExp(r'\s+'), '')}';

    return TransactionDraft(
      type: type,
      amount: amountResult.amount,
      merchant: merchant,
      category: category,
      date: timestamp,
      paymentMethod: paymentMethod,
      referenceId: refId,
      sourceHash: sourceHash,
      confidence: 0.92,
      rawSender: sender,
      purpose: merchant,
    );
  }
}
