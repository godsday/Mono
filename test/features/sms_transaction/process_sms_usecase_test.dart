import 'package:flutter_test/flutter_test.dart';
import 'package:mono/core/notifications/notification_service.dart';
import 'package:mono/features/sms_transaction/domain/services/sms_deduplication_service.dart';
import 'package:mono/features/sms_transaction/domain/usecases/process_sms_usecase.dart';
import 'package:mono/features/sms_transaction/domain/validation/transaction_draft_validator.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:mono/features/transaction/domain/usecases/add_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeTransactionRepository implements TransactionRepository {
  final List<TranscationModel> savedTransactions = [];

  @override
  Future<void> addTransaction(TranscationModel transaction) async {
    savedTransactions.add(transaction);
  }

  @override
  Future<void> clearTransactions() async {
    savedTransactions.clear();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    savedTransactions.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<TranscationModel>> getTransactions() async {
    return List.from(savedTransactions);
  }

  @override
  Future<void> updateTransaction(TranscationModel transaction) async {
    final idx = savedTransactions.indexWhere((t) => t.id == transaction.id);
    if (idx != -1) {
      savedTransactions[idx] = transaction;
    }
  }
}

class FakeNotificationService implements NotificationService {
  final List<Map<String, dynamic>> shownNotifications = [];

  @override
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    shownNotifications.add({
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
    });
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> requestPermissions() async {}

  @override
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {}

  @override
  Future<void> cancelAllNotifications() async {}

  @override
  Future<String?> getFCMToken({bool forceRefresh = false}) async => null;

  @override
  Future<void> clearCachedFCMToken() async {}
}


void main() {
  late FakeTransactionRepository fakeRepository;
  late AddTransaction addTransactionUseCase;
  late SmsDeduplicationService deduplicationService;
  late TransactionDraftValidator validator;
  late FakeNotificationService fakeNotificationService;
  late ProcessSmsUseCase processSmsUseCase;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    fakeRepository = FakeTransactionRepository();
    addTransactionUseCase = AddTransaction(fakeRepository);
    deduplicationService = SmsDeduplicationService(sharedPreferences: prefs);
    validator = TransactionDraftValidator();
    fakeNotificationService = FakeNotificationService();

    processSmsUseCase = ProcessSmsUseCase(
      addTransactionUseCase: addTransactionUseCase,
      deduplicationService: deduplicationService,
      validator: validator,
      notificationService: fakeNotificationService,
    );
  });

  test('successfully processes valid debit SMS and invokes AddTransactionUseCase', () async {
    const sms = 'Your account has been debited by INR 450 at AMAZON on 26-Aug-24. Avl Bal INR 12,500.00.';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final result = await processSmsUseCase(
      sender: 'VM-HDFCBK',
      body: sms,
      timestampMillis: timestamp,
      showNotification: true,
    );

    expect(result.status, equals(ProcessSmsStatus.saved));
    expect(result.isSuccess, isTrue);
    expect(result.draft?.amount, equals(450.0));
    expect(result.draft?.category, equals('Shopping'));

    // Verify it saved into the repository
    expect(fakeRepository.savedTransactions.length, equals(1));
    expect(fakeRepository.savedTransactions.first.amount, equals(450.0));
    expect(fakeRepository.savedTransactions.first.category, equals('Shopping'));

    // Verify notification was triggered
    expect(fakeNotificationService.shownNotifications.length, equals(1));
  });

  test('detects duplicate on second attempt and avoids saving duplicate', () async {
    const sms = 'UPI payment of Rs 850 to SWIGGY. Ref 123456';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final res1 = await processSmsUseCase(
      sender: 'AX-PhonePe',
      body: sms,
      timestampMillis: timestamp,
      showNotification: false,
    );
    expect(res1.status, equals(ProcessSmsStatus.saved));
    expect(fakeRepository.savedTransactions.length, equals(1));

    // Process identical SMS again
    final res2 = await processSmsUseCase(
      sender: 'AX-PhonePe',
      body: sms,
      timestampMillis: timestamp,
      showNotification: false,
    );
    expect(res2.status, equals(ProcessSmsStatus.duplicate));
    // Verify repository count did not increment
    expect(fakeRepository.savedTransactions.length, equals(1));
  });

  test('rejects non-financial and OTP messages without saving', () async {
    const otpSms = 'Your OTP for transaction of Rs 500 at Swiggy is 492019. Do not share.';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final result = await processSmsUseCase(
      sender: 'VM-HDFCBK',
      body: otpSms,
      timestampMillis: timestamp,
      showNotification: false,
    );

    expect(result.status, equals(ProcessSmsStatus.rejected));
    expect(fakeRepository.savedTransactions, isEmpty);
  });
}
