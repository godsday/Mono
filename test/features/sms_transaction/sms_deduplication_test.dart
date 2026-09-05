import 'package:flutter_test/flutter_test.dart';
import 'package:mono/features/sms_transaction/domain/services/sms_deduplication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SmsDeduplicationService deduplicationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    deduplicationService = SmsDeduplicationService(sharedPreferences: prefs);
  });

  test('returns false for new unprocessed hash', () async {
    const hash = 'sms_HDFCBK_450_Expense_2024_8_26_ref123';
    final isDup = await deduplicationService.isDuplicate(hash);
    expect(isDup, isFalse);
  });

  test('records hash and detects subsequent call as duplicate', () async {
    const hash = 'sms_HDFCBK_450_Expense_2024_8_26_ref123';

    await deduplicationService.recordHash(hash);
    final isDup = await deduplicationService.isDuplicate(hash);
    expect(isDup, isTrue);
  });

  test('can clear recorded hashes', () async {
    const hash = 'sms_HDFCBK_450_Expense_2024_8_26_ref123';

    await deduplicationService.recordHash(hash);
    expect(await deduplicationService.isDuplicate(hash), isTrue);

    await deduplicationService.clearHashes();
    expect(await deduplicationService.isDuplicate(hash), isFalse);
  });
}
