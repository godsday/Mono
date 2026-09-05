import '../entities/transaction_draft.dart';
import 'templates/bank_transaction_template.dart';
import 'templates/card_transaction_template.dart';
import 'templates/generic_transaction_template.dart';
import 'templates/upi_transaction_template.dart';
import 'transaction_template.dart';

class TransactionTemplateRegistry {
  final List<TransactionSmsTemplate> _templates = [];

  TransactionTemplateRegistry() {
    _registerDefaultTemplates();
  }

  void _registerDefaultTemplates() {
    registerTemplate(UpiTransactionTemplate()); // priority 90
    registerTemplate(CardTransactionTemplate()); // priority 85
    registerTemplate(BankTransactionTemplate()); // priority 80
    registerTemplate(GenericTransactionTemplate()); // priority 10
  }

  void registerTemplate(TransactionSmsTemplate template) {
    _templates.add(template);
    // Sort templates descending by priority
    _templates.sort((a, b) => b.priority.compareTo(a.priority));
  }

  List<TransactionSmsTemplate> get templates => List.unmodifiable(_templates);

  /// Iterates through registered templates to parse the SMS into a TransactionDraft
  TransactionDraft? parse({
    required String sender,
    required String body,
    required DateTime timestamp,
  }) {
    for (final template in _templates) {
      if (template.canParse(sender, body)) {
        final draft = template.parse(
          sender: sender,
          body: body,
          timestamp: timestamp,
        );
        if (draft != null) {
          return draft;
        }
      }
    }
    return null;
  }
}
