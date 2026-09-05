import 'package:flutter_test/flutter_test.dart';
import 'package:mono/features/sms_transaction/domain/parser/candidate_detector.dart';

void main() {
  late CandidateDetector detector;
  final now = DateTime.now();

  setUp(() {
    detector = CandidateDetector();
  });

  group('CandidateDetector - Positive Financial Triggers', () {
    test('detects debit SMS as candidate', () {
      const sms = 'Your account has been debited by INR 450.00 at AMAZON on 26-Aug-24. Avl Bal INR 12,500.00.';
      final result = detector.detect(sender: 'VM-HDFCBK', body: sms, timestamp: now);
      expect(result.isCandidate, isTrue);
      expect(result.rejectionReason, isNull);
    });

    test('detects credit / salary SMS as candidate', () {
      const sms = 'INR 50,000.00 credited to your account towards salary. Total Bal INR 1,50,000.00.';
      final result = detector.detect(sender: 'VK-SBIINB', body: sms, timestamp: now);
      expect(result.isCandidate, isTrue);
    });

    test('detects UPI payment SMS as candidate', () {
      const sms = 'UPI payment of Rs 850 to SWIGGY successfully completed. UPI Ref no 9876543210.';
      final result = detector.detect(sender: 'AX-PhonePe', body: sms, timestamp: now);
      expect(result.isCandidate, isTrue);
    });

    test('detects ATM withdrawal SMS as candidate', () {
      const sms = 'Cash withdrawal of Rs 2000 from ATM 4321 on 26-Aug-24. Avl Bal: Rs 15000.';
      final result = detector.detect(sender: 'VM-ICICIB', body: sms, timestamp: now);
      expect(result.isCandidate, isTrue);
    });

    test('detects POS credit card swipe as candidate', () {
      const sms = 'INR 1,499.00 spent on your Credit Card ending 1234 at RELIANCE RETAIL.';
      final result = detector.detect(sender: 'VM-AXISBK', body: sms, timestamp: now);
      expect(result.isCandidate, isTrue);
    });
  });

  group('CandidateDetector - Rejections (OTP, Promo, Delivery, Spam)', () {
    test('rejects OTP / verification code SMS', () {
      const sms = 'Your OTP for transaction of Rs 500.00 at Swiggy is 492019. Do not share this code with anyone.';
      final result = detector.detect(sender: 'VM-HDFCBK', body: sms, timestamp: now);
      expect(result.isCandidate, isFalse);
      expect(result.rejectionReason, contains('OTP'));
    });

    test('rejects promotional loan / reward SMS', () {
      const sms = 'Congratulations! You are pre-approved for a personal loan of Rs 5,00,000. Apply now at loan.com';
      final result = detector.detect(sender: 'VM-LOANS', body: sms, timestamp: now);
      expect(result.isCandidate, isFalse);
      expect(result.rejectionReason, contains('Promotional'));
    });

    test('rejects delivery / order shipment SMS', () {
      const sms = 'Your package for order value Rs 450 is out for delivery. Tracking id: TRK998877.';
      final result = detector.detect(sender: 'VK-EKART', body: sms, timestamp: now);
      expect(result.isCandidate, isFalse);
      expect(result.rejectionReason, contains('Delivery'));
    });

    test('rejects generic non-financial message', () {
      const sms = 'Hey! Are we still meeting for lunch today? Let me know.';
      final result = detector.detect(sender: '+919876543210', body: sms, timestamp: now);
      expect(result.isCandidate, isFalse);
    });

    test('rejects empty message body', () {
      final result = detector.detect(sender: 'VM-TEST', body: '   ', timestamp: now);
      expect(result.isCandidate, isFalse);
    });
  });
}
