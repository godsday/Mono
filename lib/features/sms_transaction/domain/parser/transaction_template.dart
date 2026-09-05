import '../entities/transaction_draft.dart';

abstract class TransactionSmsTemplate {
  /// Unique template identifier (e.g. 'bank_hdfc', 'upi_generic', 'card_pos')
  String get templateId;

  /// Priority of template evaluation (higher priority evaluates first)
  int get priority;

  /// Checks if this template can parse the given SMS sender and body
  bool canParse(String sender, String body);

  /// Extracts a TransactionDraft from the SMS
  TransactionDraft? parse({
    required String sender,
    required String body,
    required DateTime timestamp,
  });
}
