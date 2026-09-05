import 'package:flutter_test/flutter_test.dart';
import 'package:mono/features/sms_transaction/domain/parser/candidate_detector.dart';
import 'package:mono/features/sms_transaction/domain/parser/transaction_template_registry.dart';
import 'package:mono/features/sms_transaction/domain/parser/sms_parser_engine.dart';

void main() {
  group('User provided SMS cases', () {
    final date = DateTime(2026, 9, 3);
    
    test('SMS 1 - Income UPI', () {
      const sms = 'Dear Customer, Acct XX839 is credited with Rs 8267.00 on 03-Sep-26 from SARAVANAN S. UPI:128953837264-ICICI Bank.';
      final result = SmsParserEngine.parseFull(sender: 'ICICI', body: sms, date: date);
      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.type, 'Income');
      expect(result.draft!.amount, 8267.0);
    });

    test('SMS 2 - Promo Loan', () {
      const sms = 'Update. Hi, There has been a revision to your Pay Later a/c XXX0130 status. We confirm that your personal loan upto 4,00,000/- is now ready. For full account details, kindly check here: https://u.axio.ac/axo/uVlI76rrdkJE -axio';
      final result = SmsParserEngine.parseFull(sender: 'axio', body: sms, date: date);
      expect(result.candidate.isCandidate, isFalse);
    });

    test('SMS 3 - Expense Autopay', () {
      const sms = 'ICICI Bank SAVINGS Account XX839 will be debited for Rs 3000.00 on 01-Sep-26 towards Autopay for ICCL - Mutual F, Mandate Created via GROWW, Unique Mandate Number 0c48c5a1ad694c2dbc5e7a1bdd43e308@yesg';
      final result = SmsParserEngine.parseFull(sender: 'ICICI', body: sms, date: date);
      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.type, 'Expense');
      expect(result.draft!.amount, 3000.0);
    });

    test('SMS 4 - Expense UPI', () {
      const sms = 'Dear UPI user A/C X7235 debited by 7500.00 on date 11Jul26 trf to MUHAMMED RAFI K Refno 619299766731 If not u? call-1800111109 for other services-18001234-SBI';
      final result = SmsParserEngine.parseFull(sender: 'SBI', body: sms, date: date);
      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.type, 'Expense');
      expect(result.draft!.amount, 7500.0);
    });

    test('SMS 5 - Due reminder 1', () {
      const sms = "Payment for IndusInd Credit Card 4948 is due on 04-Sep-26. Total Due - Rs. 8267.00 & Min Due - 8267.00. Click https://pay.billdesk.com/cardnet-instapay/induscard to pay, ignore if paid. Bank will report your Credit Card account as 'Past Due' to Credit Information Agencies if the Minimum Amount Due remains unpaid for more than 3 days from the payment due date - IndusInd Bank";
      final result = SmsParserEngine.parseFull(sender: 'IndusInd', body: sms, date: date);
      expect(result.candidate.isCandidate, isFalse);
    });

    test('SMS 6 - Expense Credit Card', () {
      const sms = 'ICICI Bank Credit Card XX4004 debited for INR 25.00 on 02-Sep-26 for UPI-661114662450-Shaberst. To dispute call 18001080/SMS BLOCK 4004 to 9215676766';
      final result = SmsParserEngine.parseFull(sender: 'ICICI', body: sms, date: date);
      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.type, 'Expense');
      expect(result.draft!.amount, 25.0);
    });

    test('SMS 7 - Due reminder 2', () {
      const sms = 'Payment of INR 2416.72 for Axis Bank Credit Card no. XX1474 is due on 09-09-26 with minimum amount due of INR 623.8. Ignore if paid.';
      final result = SmsParserEngine.parseFull(sender: 'Axis', body: sms, date: date);
      expect(result.candidate.isCandidate, isFalse);
    });

    test('SMS 8 - Expense Card', () {
      const sms = 'NR 1,204.00 spent on IndusInd Card XX4948 on 29-08-2026 08:20:55 pm at AMAZON PAY INDIA PRIVATE. Avl Lmt: INR 98,353.89. To dispute, call 18602677777/SMS BLOCK 4948 to 5676757';
      final result = SmsParserEngine.parseFull(sender: 'IndusInd', body: sms, date: date);
      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.type, 'Expense');
      expect(result.draft!.amount, 1204.0);
    });

    test('SMS 9 - Multiline Expense Card', () {
      const sms = 'Spent INR 36\nAxis Bank Card no. XX1474\n03-09-26 09:42:43 IST\nPKD STORE\nAvl Limit: INR 141598.62\nNot you? SMS BLOCK 1474 to 919951860002';
      final result = SmsParserEngine.parseFull(sender: 'Axis', body: sms, date: date);
      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.type, 'Expense');
      expect(result.draft!.amount, 36.0);
    });

    test('SMS 10 - Income Bank credited', () {
      const sms = 'Dear SBI User, your A/c X1839-credited by Rs.8267 on 03Sep26 transfer from SARAVANAN S Ref No 128953837264 -SBI';
      final result = SmsParserEngine.parseFull(sender: 'SBI', body: sms, date: date);
      expect(result.candidate.isCandidate, isTrue);
      expect(result.draft, isNotNull);
      expect(result.draft!.type, 'Income');
      expect(result.draft!.amount, 8267.0);
    });
  });
}
