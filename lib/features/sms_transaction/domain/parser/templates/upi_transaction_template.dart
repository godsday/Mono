import '../../entities/transaction_draft.dart';
import '../transaction_template.dart';

import '../utils/amount_extractor.dart';
import '../utils/category_mapper.dart';
import '../utils/merchant_extractor.dart';

class UpiTransactionTemplate implements TransactionSmsTemplate {
  @override
  String get templateId => 'upi_templates';

  @override
  int get priority => 90;

  static final RegExp _upiKeywords = RegExp(
    r'\b(?:UPI|VPA|BHIM|GPAY|PHONEPE|PAYTM|CRED)\b',
    caseSensitive: false,
  );

  static final RegExp _refPattern = RegExp(
    r'\b(?:UPI\s*Ref(?:\s*no)?|rrn|txn\s*id|ref\s*no)\s*[:#\-]?\s*([a-zA-Z0-9]+)',
    caseSensitive: false,
  );

  @override
  bool canParse(String sender, String body) {
    return _upiKeywords.hasMatch(body) || _upiKeywords.hasMatch(sender);
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
    final isCredit = lower.contains('credited') ||
        lower.contains('received') ||
        lower.contains('deposited') ||
        lower.contains('refund');

    final type = isCredit ? 'Income' : 'Expense';
    final merchant = MerchantExtractor.extract(body) ?? (isCredit ? 'UPI Transfer' : 'UPI Payment');

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
      paymentMethod: 'UPI',
      referenceId: refId,
      sourceHash: sourceHash,
      confidence: 0.95,
      rawSender: sender,
      purpose: merchant,
    );
  }
}
