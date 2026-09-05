import 'package:flutter_test/flutter_test.dart';
import 'package:mono/features/sms_transaction/domain/parser/sms_parser_engine.dart';
import 'package:mono/features/sms_transaction/domain/parser/transaction_template_registry.dart';
import 'package:mono/features/sms_transaction/domain/parser/utils/category_mapper.dart';
import 'package:mono/features/sms_transaction/domain/parser/utils/merchant_extractor.dart';

void main() {
  late TransactionTemplateRegistry registry;
  final testDate = DateTime(2024, 8, 26, 14, 30);

  setUp(() {
    registry = TransactionTemplateRegistry();
  });

  group('Template Parser - Examples from Requirements', () {
    test('Example 1: "Your account has been debited by INR 450 at AMAZON."', () {
      const sms = 'Your account has been debited by INR 450 at AMAZON.';
      final draft = registry.parse(sender: 'VM-HDFCBK', body: sms, timestamp: testDate);

      expect(draft, isNotNull);
      expect(draft!.type, equals('Expense'));
      expect(draft.amount, equals(450.0));
      expect(draft.merchant?.toUpperCase(), contains('AMAZON'));
      expect(draft.category, equals('Shopping'));
    });

    test('Example 2: "INR 50,000 credited to your account towards salary."', () {
      const sms = 'INR 50,000 credited to your account towards salary.';
      final draft = registry.parse(sender: 'VK-SBIINB', body: sms, timestamp: testDate);

      expect(draft, isNotNull);
      expect(draft!.type, equals('Income'));
      expect(draft.amount, equals(50000.0));
      expect(draft.category, equals('Salary'));
    });

    test('Example 3: "UPI payment of Rs 850 to SWIGGY."', () {
      const sms = 'UPI payment of Rs 850 to SWIGGY.';
      final draft = registry.parse(sender: 'AX-PhonePe', body: sms, timestamp: testDate);

      expect(draft, isNotNull);
      expect(draft!.type, equals('Expense'));
      expect(draft.amount, equals(850.0));
      expect(draft.merchant?.toUpperCase(), contains('SWIGGY'));
      expect(draft.paymentMethod, equals('UPI'));
      expect(draft.category, equals('Food'));
    });

    test('ATM Cash Withdrawal', () {
      const sms = 'Cash withdrawal of Rs 2000 from ATM on 26-Aug-24. Avl Bal Rs 15000.';
      final draft = registry.parse(sender: 'VM-ICICIB', body: sms, timestamp: testDate);

      expect(draft, isNotNull);
      expect(draft!.type, equals('Expense'));
      expect(draft.amount, equals(2000.0));
      expect(draft.paymentMethod, equals('ATM'));
      expect(draft.category, equals('Debit'));
    });
  });

  group('Category Mapping Tests', () {
    test('Shopping mapping: Amazon, Flipkart, Myntra', () {
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Flipkart', fullBody: ''), equals('Shopping'));
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Myntra', fullBody: ''), equals('Shopping'));
    });

    test('Food mapping: Swiggy, Zomato, Instamart, Zepto', () {
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Zomato', fullBody: ''), equals('Food'));
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Blinkit', fullBody: ''), equals('Food'));
    });

    test('Travel mapping: Uber, Ola, Petrol, IRCTC', () {
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Uber', fullBody: ''), equals('Travel'));
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'HPCL Petrol', fullBody: ''), equals('Travel'));
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'IRCTC', fullBody: ''), equals('Travel'));
    });

    test('Entertainment mapping: Netflix, BookMyShow', () {
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Netflix', fullBody: ''), equals('Entertainment'));
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Bookmyshow', fullBody: ''), equals('Entertainment'));
    });

    test('Utilities mapping: BESCOM, Jio Recharge', () {
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'BESCOM', fullBody: ''), equals('Utilities'));
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Jio Recharge', fullBody: ''), equals('Utilities'));
    });

    test('Medical mapping: Apollo Pharmacy', () {
      expect(CategoryMapper.mapCategory(type: 'Expense', merchant: 'Apollo Pharmacy', fullBody: ''), equals('Medical'));
    });
  });

  group('SmsParserEngine - Full Parser Pipeline', () {
    test('parses full candidate and returns valid draft', () {
      const sms = 'Your A/c is debited by INR 350.00 at UBER on 26-Aug-24. Avl Bal INR 5,000.00.';
      final result = SmsParserEngine.parseFull(sender: 'VM-HDFCBK', body: sms, date: testDate);

      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.amount, equals(350.0));
      expect(result.draft!.category, equals('Travel'));
    });

    test('rejects OTP and returns null draft', () {
      const sms = 'Your OTP is 998877 for transaction Rs 500 at Swiggy. Do not share.';
      final result = SmsParserEngine.parseFull(sender: 'VM-HDFCBK', body: sms, date: testDate);

      expect(result.candidate.isCandidate, isFalse);
      expect(result.draft, isNull);
    });
  });
}
