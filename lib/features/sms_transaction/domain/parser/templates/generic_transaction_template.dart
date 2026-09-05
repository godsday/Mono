import '../../entities/transaction_draft.dart';
import '../transaction_template.dart';

import '../utils/amount_extractor.dart';
import '../utils/category_mapper.dart';
import '../utils/merchant_extractor.dart';

class GenericTransactionTemplate implements TransactionSmsTemplate {
  @override
  String get templateId => 'generic_parser';

  @override
  int get priority => 10; // Lowest priority fallback

  static final RegExp _refPattern = RegExp(
    r'\b(?:ref(?:\s*no)?|rrn|utr|txn\s*(?:id|no)?)\s*[:#\-]?\s*([a-zA-Z0-9]+)',
    caseSensitive: false,
  );

  @override
  bool canParse(String sender, String body) {
    // Generic parser can attempt to parse any candidate
    return true;
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
    final cleanLower = lower.replaceAll('credit card', '').replaceAll('credit limit', '');
    
    final isCredit = cleanLower.contains('credited') ||
        cleanLower.contains('received') ||
        cleanLower.contains('deposited') ||
        cleanLower.contains('refund') ||
        cleanLower.contains(RegExp(r'\bcredit\b'));

    final type = isCredit ? 'Income' : 'Expense';
    final merchant = MerchantExtractor.extract(body) ?? (isCredit ? 'Income' : 'Expense');

    final refMatch = _refPattern.firstMatch(body);
    final refId = refMatch?.group(1);

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
      paymentMethod: 'Other',
      referenceId: refId,
      sourceHash: sourceHash,
      confidence: 0.85,
      rawSender: sender,
      purpose: merchant,
    );
  }
}
