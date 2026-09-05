import 'dart:isolate';
import 'package:mono/core/notifications/notification_service.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/features/transaction/domain/usecases/add_transaction.dart';
import '../entities/transaction_draft.dart';
import '../parser/sms_parser_engine.dart';
import '../services/sms_deduplication_service.dart';
import '../validation/transaction_draft_validator.dart';

enum ProcessSmsStatus {
  saved,
  duplicate,
  rejected,
  invalid,
}

class ProcessSmsResult {
  final ProcessSmsStatus status;
  final String? message;
  final TransactionDraft? draft;
  final TranscationModel? savedTransaction;

  const ProcessSmsResult({
    required this.status,
    this.message,
    this.draft,
    this.savedTransaction,
  });

  bool get isSuccess => status == ProcessSmsStatus.saved;
}

class ProcessSmsUseCase {
  final AddTransaction addTransactionUseCase;
  final SmsDeduplicationService deduplicationService;
  final TransactionDraftValidator validator;
  final NotificationService notificationService;

  ProcessSmsUseCase({
    required this.addTransactionUseCase,
    required this.deduplicationService,
    required this.validator,
    required this.notificationService,
  });

  /// Full pipeline executing candidate detection, isolate parsing, validation, deduplication,
  /// and persistence through Mono's AddTransaction use case.
  Future<ProcessSmsResult> call({
    required String sender,
    required String body,
    required int timestampMillis,
    bool showNotification = true,
  }) async {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMillis);

    // 1. Parallel isolate execution for parsing
    final draft = await Isolate.run(() {
      return SmsParserEngine.parseToDraft(
        sender: sender,
        body: body,
        date: date,
      );
    });

    if (draft == null) {
      return const ProcessSmsResult(
        status: ProcessSmsStatus.rejected,
        message: 'SMS does not qualify as a financial transaction candidate',
      );
    }

    // 2. Validate transaction draft
    final validation = validator.validate(draft);
    if (!validation.isValid) {
      return ProcessSmsResult(
        status: ProcessSmsStatus.invalid,
        message: validation.errorMessage ?? 'Validation failed',
        draft: draft,
      );
    }

    // 3. Deduplication check
    final isDuplicate = await deduplicationService.isDuplicate(draft.sourceHash);
    if (isDuplicate) {
      return ProcessSmsResult(
        status: ProcessSmsStatus.duplicate,
        message: 'Transaction already recorded (Duplicate)',
        draft: draft,
      );
    }

    // 4. Transform to Mono's TranscationModel
    final transactionModel = TranscationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: draft.type,
      amount: draft.amount,
      date: draft.date,
      category: draft.category,
      purpose: draft.merchant ?? draft.purpose ?? 'SMS Auto Capture',
    );

    // 5. Save through existing AddTransaction Clean Architecture usecase
    await addTransactionUseCase(transactionModel);

    // 6. Record deduplication hash
    await deduplicationService.recordHash(draft.sourceHash);

    // 7. Show Instant Notification
    if (showNotification) {
      final formattedAmount = draft.amount.toStringAsFixed(draft.amount.truncateToDouble() == draft.amount ? 0 : 2);
      final title = 'Smart Transaction Captured';
      final isExpense = draft.type.toLowerCase() == 'expense';
      final bodyText = '${isExpense ? 'Spent' : 'Received'} ₹$formattedAmount for ${draft.merchant ?? draft.category}';

      await notificationService.showInstantNotification(
        id: draft.sourceHash.hashCode,
        title: title,
        body: bodyText,
      );
    }

    return ProcessSmsResult(
      status: ProcessSmsStatus.saved,
      message: 'Transaction successfully captured and saved',
      draft: draft,
      savedTransaction: transactionModel,
    );
  }
}
