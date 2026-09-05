import 'package:flutter_test/flutter_test.dart';
import 'package:mono/features/sms_transaction/domain/parser/utils/amount_extractor.dart';

void main() {
  group('AmountExtractor - Formats & Symbols', () {
    test('extracts ₹ symbol amount: ₹450 and ₹ 450', () {
      final res1 = AmountExtractor.extract('Your account debited by ₹450 at Store');
      expect(res1, isNotNull);
      expect(res1!.amount, equals(450.0));

      final res2 = AmountExtractor.extract('debited by ₹ 450.50 at Store');
      expect(res2, isNotNull);
      expect(res2!.amount, equals(450.50));
    });

    test('extracts Rs symbol amount: Rs 450 and Rs. 450', () {
      final res1 = AmountExtractor.extract('paid Rs 450 at CAFE');
      expect(res1, isNotNull);
      expect(res1!.amount, equals(450.0));

      final res2 = AmountExtractor.extract('debited by Rs. 450.00 at CAFE');
      expect(res2, isNotNull);
      expect(res2!.amount, equals(450.0));
    });

    test('extracts INR format with commas: INR 450 and INR 1,50,000.00', () {
      final res1 = AmountExtractor.extract('debited by INR 450 at AMAZON');
      expect(res1, isNotNull);
      expect(res1!.amount, equals(450.0));

      final res2 = AmountExtractor.extract('credited with INR 1,50,000.00 towards salary');
      expect(res2, isNotNull);
      expect(res2!.amount, equals(150000.0));
    });
  });

  group('AmountExtractor - Balance Exclusion', () {
    test('does NOT confuse available balance with transaction amount', () {
      const sms = 'debited INR 450. Available balance INR 12,500';
      final result = AmountExtractor.extract(sms);
      expect(result, isNotNull);
      expect(result!.amount, equals(450.0));
      expect(result.availableBalance, equals(12500.0));
    });

    test('excludes Avl Bal and Total Bal correctly', () {
      const sms = 'Your A/c *1234 is credited with Rs. 50,000.00. Avl Bal: Rs 1,75,450.00.';
      final result = AmountExtractor.extract(sms);
      expect(result, isNotNull);
      expect(result!.amount, equals(50000.0));
      expect(result.availableBalance, equals(175450.0));
    });

    test('handles ATM withdrawal and remaining balance', () {
      const sms = 'Cash withdrawal of Rs 2000 from ATM on 26-Aug. Bal Rs 8,500.';
      final result = AmountExtractor.extract(sms);
      expect(result, isNotNull);
      expect(result!.amount, equals(2000.0));
      expect(result.availableBalance, equals(8500.0));
    });
  });
}
