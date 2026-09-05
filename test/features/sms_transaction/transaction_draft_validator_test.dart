import 'package:flutter_test/flutter_test.dart';
import 'package:mono/features/sms_transaction/domain/entities/transaction_draft.dart';
import 'package:mono/features/sms_transaction/domain/validation/transaction_draft_validator.dart';

void main() {
  late TransactionDraftValidator validator;
  final validDate = DateTime.now();

  setUp(() {
    validator = TransactionDraftValidator();
  });

  test('validates correct draft successfully', () {
    final draft = TransactionDraft(
      type: 'Expense',
      amount: 450.0,
      merchant: 'Amazon',
      category: 'Shopping',
      date: validDate,
      sourceHash: 'hash123',
      confidence: 0.95,
    );

    final result = validator.validate(draft);
    expect(result.isValid, isTrue);
  });

  test('rejects draft with zero or negative amount', () {
    final draft = TransactionDraft(
      type: 'Expense',
      amount: 0.0,
      category: 'Shopping',
      date: validDate,
      sourceHash: 'hash123',
      confidence: 0.95,
    );

    final result = validator.validate(draft);
    expect(result.isValid, isFalse);
    expect(result.errorMessage, contains('greater than 0'));
  });

  test('rejects draft with invalid transaction type', () {
    final draft = TransactionDraft(
      type: 'TransferUnknown',
      amount: 500.0,
      category: 'Shopping',
      date: validDate,
      sourceHash: 'hash123',
      confidence: 0.95,
    );

    final result = validator.validate(draft);
    expect(result.isValid, isFalse);
    expect(result.errorMessage, contains('must be Expense or Income'));
  });

  test('rejects draft with future date', () {
    final draft = TransactionDraft(
      type: 'Expense',
      amount: 500.0,
      category: 'Shopping',
      date: DateTime.now().add(const Duration(days: 5)),
      sourceHash: 'hash123',
      confidence: 0.95,
    );

    final result = validator.validate(draft);
    expect(result.isValid, isFalse);
    expect(result.errorMessage, contains('future'));
  });

  test('rejects draft with low confidence score', () {
    final draft = TransactionDraft(
      type: 'Expense',
      amount: 500.0,
      category: 'Shopping',
      date: validDate,
      sourceHash: 'hash123',
      confidence: 0.3,
    );

    final result = validator.validate(draft);
    expect(result.isValid, isFalse);
    expect(result.errorMessage, contains('threshold'));
  });
}
