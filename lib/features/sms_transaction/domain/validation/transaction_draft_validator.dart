import '../entities/transaction_draft.dart';

class DraftValidationResult {
  final bool isValid;
  final String? errorMessage;

  const DraftValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  static const DraftValidationResult success = DraftValidationResult(isValid: true);
}

class TransactionDraftValidator {
  static const double minimumConfidence = 0.6;

  static const List<String> validCategories = [
    // Income
    'Salary', 'Gift', 'Rental', 'Credit',
    // Expense
    'Shopping', 'Travel', 'Food', 'Medical', 'Insurance', 'Utilities',
    'Education', 'Entertainment', 'Debit',
    // Common fallback
    'Other',
  ];

  DraftValidationResult validate(TransactionDraft draft) {
    // 1. Amount validation
    if (draft.amount <= 0 || draft.amount.isNaN || draft.amount.isInfinite) {
      return const DraftValidationResult(
        isValid: false,
        errorMessage: 'Invalid transaction amount (must be greater than 0)',
      );
    }

    // 2. Type validation
    final typeLower = draft.type.toLowerCase();
    if (typeLower != 'expense' && typeLower != 'income') {
      return DraftValidationResult(
        isValid: false,
        errorMessage: 'Invalid transaction type "${draft.type}" (must be Expense or Income)',
      );
    }

    // 3. Category validation
    if (draft.category.trim().isEmpty) {
      return const DraftValidationResult(
        isValid: false,
        errorMessage: 'Transaction category cannot be empty',
      );
    }

    // 4. Date validation
    final now = DateTime.now();
    // Cannot be more than 1 day in the future
    if (draft.date.isAfter(now.add(const Duration(days: 1)))) {
      return const DraftValidationResult(
        isValid: false,
        errorMessage: 'Transaction date cannot be in the future',
      );
    }

    // 5. Confidence validation
    if (draft.confidence < minimumConfidence) {
      return DraftValidationResult(
        isValid: false,
        errorMessage: 'Confidence score ${draft.confidence} is below threshold $minimumConfidence',
      );
    }

    return DraftValidationResult.success;
  }
}
