import '../../entities/transaction_draft.dart';
import '../transaction_template.dart';

import '../utils/amount_extractor.dart';
import '../utils/category_mapper.dart';
import '../utils/merchant_extractor.dart';

class BankTransactionTemplate implements TransactionSmsTemplate {
  @override
  String get templateId => 'bank_templates';

  @override
  int get priority => 80;

  static final RegExp _bankSenderPattern = RegExp(
    r'(?:HDFC|SBI|ICICI|AXIS|KOTAK|PNB|BOB|CANARA|UNIONB|IDFC|YESB|INDUS|RBL|CITI|HSBC|SCB|FEDBNK|KVB|IOB|UCO|MAHAB)',
    caseSensitive: false,
  );

  static final RegExp _bankKeywords = RegExp(
    r'\b(?:A\/c|Acct|Account)\b.*?\b(?:debited|credited|withdrawn|deposited)\b',
    caseSensitive: false,
  );

  static final RegExp _refPattern = RegExp(
    r'\b(?:ref(?:\s*no)?|rrn|utr|txn\s*(?:id|no)?)\s*[:#\-]?\s*([a-zA-Z0-9]+)',
    caseSensitive: false,
  );

  @override
  bool canParse(String sender, String body) {
    return _bankSenderPattern.hasMatch(sender) || _bankKeywords.hasMatch(body);
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
    final isCredit = lower.contains('credited') || lower.contains('deposited') || lower.contains('refund of');
    final isAtm = lower.contains('atm') || lower.contains('withdrawn') || lower.contains('cash withdrawal');

    final type = isCredit ? 'Income' : 'Expense';
    final merchant = MerchantExtractor.extract(body) ?? (isAtm ? 'ATM Withdrawal' : (isCredit ? 'Bank Credit' : 'Bank Transfer'));

    final refMatch = _refPattern.firstMatch(body);
    final refId = refMatch?.group(1);

    final paymentMethod = isAtm ? 'ATM' : 'Bank Transfer';
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
