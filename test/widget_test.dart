import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mono/core/notifications/notification_service.dart';
import 'package:mono/core/di/injection_container.dart';
import 'package:mono/features/sms_transaction/domain/services/sms_deduplication_service.dart';
import 'package:mono/features/sms_transaction/domain/usecases/parse_sms_draft_usecase.dart';
import 'package:mono/features/sms_transaction/domain/usecases/process_sms_usecase.dart';
import 'package:mono/features/sms_transaction/domain/validation/transaction_draft_validator.dart';
import 'package:mono/features/sms_transaction/presentation/pages/sms_parser_debug_screen.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:mono/features/transaction/domain/usecases/add_transaction.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class FakeTransactionRepo implements TransactionRepository {
  @override
  Future<void> addTransaction(TranscationModel transaction) async {}
  @override
  Future<void> clearTransactions() async {}
  @override
  Future<void> deleteTransaction(String id) async {}
  @override
  Future<List<TranscationModel>> getTransactions() async => [];
  @override
  Future<void> updateTransaction(TranscationModel transaction) async {}
}

class FakeNotificationService implements NotificationService {
  @override
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {}
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
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final repo = FakeTransactionRepo();
    final addTx = AddTransaction(repo);
    final notif = FakeNotificationService();
    final dedup = SmsDeduplicationService(sharedPreferences: prefs);
    final validator = TransactionDraftValidator();

    sl.registerLazySingleton<ParseSmsDraftUseCase>(() => ParseSmsDraftUseCase());
    sl.registerLazySingleton<ProcessSmsUseCase>(() => ProcessSmsUseCase(
          addTransactionUseCase: addTx,
          deduplicationService: dedup,
          validator: validator,
          notificationService: notif,
        ));
    sl.registerLazySingleton<TransactionDraftValidator>(() => validator);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('SmsParserDebugScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            home: SmsParserDebugScreen(),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('SMS Parser [DEBUG]'), findsOneWidget);
    expect(find.text('Parse (Isolate)'), findsOneWidget);
    expect(find.text('Simulate Capture'), findsOneWidget);
  });
}
