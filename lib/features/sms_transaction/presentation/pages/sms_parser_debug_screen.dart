import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/features/widgets/snackbar.dart';
import 'package:mono/core/di/injection_container.dart';
import 'package:mono/features/sms_transaction/domain/entities/transaction_draft.dart';
import 'package:mono/features/sms_transaction/domain/parser/sms_parser_engine.dart';
import 'package:mono/features/sms_transaction/domain/usecases/parse_sms_draft_usecase.dart';
import 'package:mono/features/sms_transaction/domain/usecases/process_sms_usecase.dart';
import 'package:mono/features/sms_transaction/domain/validation/transaction_draft_validator.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SmsParserDebugScreen extends StatefulWidget {
  const SmsParserDebugScreen({super.key});

  @override
  State<SmsParserDebugScreen> createState() => _SmsParserDebugScreenState();
}

class _SmsParserDebugScreenState extends State<SmsParserDebugScreen> {
  final TextEditingController _senderController =
      TextEditingController(text: 'VM-HDFCBK');
  final TextEditingController _bodyController = TextEditingController(
      text:
          'Your account has been debited by INR 450.00 at AMAZON on 26-Aug-24. Avl Bal INR 12,500.00. Ref 123456');

  bool _isParsing = false;
  bool _isSaving = false;
  SmsParserResult? _parseResult;
  DraftValidationResult? _validationResult;
  ProcessSmsResult? _processResult;

  final ParseSmsDraftUseCase _parseUseCase = sl<ParseSmsDraftUseCase>();
  final ProcessSmsUseCase _processUseCase = sl<ProcessSmsUseCase>();
  final TransactionDraftValidator _validator = sl<TransactionDraftValidator>();

  final List<Map<String, String>> _samplePresets = [
    {
      'label': 'Debit (Amazon)',
      'sender': 'VM-HDFCBK',
      'body':
          'Your account has been debited by INR 450.00 at AMAZON on 26-Aug-24. Avl Bal INR 12,500.00. Ref 123456',
    },
    {
      'label': 'Credit (Salary)',
      'sender': 'VK-SBIINB',
      'body':
          'INR 50,000.00 credited to your account towards salary on 26-Aug-2024. Total Bal INR 1,50,000.00.',
    },
    {
      'label': 'UPI (Swiggy)',
      'sender': 'AX-PhonePe',
      'body':
          'UPI payment of Rs 850.00 to SWIGGY successfully completed. UPI Ref no 9876543210. Avl Bal Rs 5,400.',
    },
    {
      'label': 'ATM Cash',
      'sender': 'VM-ICICIB',
      'body':
          'Cash withdrawal of Rs 2000 from ATM 4321 on 26-Aug-24. Avl Bal: Rs 15000. Ref 887766.',
    },
    {
      'label': 'OTP (Reject)',
      'sender': 'VM-HDFCBK',
      'body':
          'Your OTP for transaction of Rs 500.00 at Swiggy is 492019. Do not share this code with anyone.',
    },
    {
      'label': 'Promo (Reject)',
      'sender': 'VM-LOANS',
      'body':
          'Congratulations! You are pre-approved for a personal loan of Rs 5,00,000. Apply now at loan.com',
    },
    {
      'label': 'Delivery (Reject)',
      'sender': 'VK-EKART',
      'body':
          'Your package for order value Rs 450 is out for delivery. Tracking id: TRK998877.',
    },
    {
      'label': 'User 1: UPI Credit',
      'sender': 'ICICI',
      'body': 'Dear Customer, Acct XX839 is credited with Rs 8267.00 on 03-Sep-26 from SARAVANAN S. UPI:128953837264-ICICI Bank.',
    },
    {
      'label': 'User 2: Promo Loan',
      'sender': 'axio',
      'body': 'Update. Hi, There has been a revision to your Pay Later a/c XXX0130 status. We confirm that your personal loan upto 4,00,000/- is now ready. For full account details, kindly check here: https://u.axio.ac/axo/uVlI76rrdkJE -axio',
    },
    {
      'label': 'User 3: Autopay Expense',
      'sender': 'ICICI',
      'body': 'ICICI Bank SAVINGS Account XX839 will be debited for Rs 3000.00 on 01-Sep-26 towards Autopay for ICCL - Mutual F, Mandate Created via GROWW, Unique Mandate Number 0c48c5a1ad694c2dbc5e7a1bdd43e308@yesg',
    },
    {
      'label': 'User 4: UPI Expense',
      'sender': 'SBI',
      'body': 'Dear UPI user A/C X7235 debited by 7500.00 on date 11Jul26 trf to MUHAMMED RAFI K Refno 619299766731 If not u? call-1800111109 for other services-18001234-SBI',
    },
    {
      'label': 'User 5: Due Reminder 1',
      'sender': 'IndusInd',
      'body': "Payment for IndusInd Credit Card 4948 is due on 04-Sep-26. Total Due - Rs. 8267.00 & Min Due - 8267.00. Click https://pay.billdesk.com/cardnet-instapay/induscard to pay, ignore if paid. Bank will report your Credit Card account as 'Past Due' to Credit Information Agencies if the Minimum Amount Due remains unpaid for more than 3 days from the payment due date - IndusInd Bank",
    },
    {
      'label': 'User 6: Card Expense',
      'sender': 'ICICI',
      'body': 'ICICI Bank Credit Card XX4004 debited for INR 25.00 on 02-Sep-26 for UPI-661114662450-Shaberst. To dispute call 18001080/SMS BLOCK 4004 to 9215676766',
    },
    {
      'label': 'User 7: Due Reminder 2',
      'sender': 'Axis',
      'body': 'Payment of INR 2416.72 for Axis Bank Credit Card no. XX1474 is due on 09-09-26 with minimum amount due of INR 623.8. Ignore if paid.',
    },
    {
      'label': 'User 8: Spent Card',
      'sender': 'IndusInd',
      'body': 'NR 1,204.00 spent on IndusInd Card XX4948 on 29-08-2026 08:20:55 pm at AMAZON PAY INDIA PRIVATE. Avl Lmt: INR 98,353.89. To dispute, call 18602677777/SMS BLOCK 4948 to 5676757',
    },
    {
      'label': 'User 9: Multiline Card',
      'sender': 'Axis',
      'body': 'Spent INR 36\nAxis Bank Card no. XX1474\n03-09-26 09:42:43 IST\nPKD STORE\nAvl Limit: INR 141598.62\nNot you? SMS BLOCK 1474 to 919951860002',
    },
    {
      'label': 'User 10: Bank Credit',
      'sender': 'SBI',
      'body': 'Dear SBI User, your A/c X1839-credited by Rs.8267 on 03Sep26 transfer from SARAVANAN S Ref No 128953837264 -SBI',
    },
  ];

  Future<void> _runParse() async {
    setState(() {
      _isParsing = true;
      _parseResult = null;
      _validationResult = null;
      _processResult = null;
    });

    try {
      final result = await _parseUseCase(
        sender: _senderController.text,
        body: _bodyController.text,
      );

      DraftValidationResult? validation;
      if (result.draft != null) {
        validation = _validator.validate(result.draft!);
      }

      setState(() {
        _parseResult = result;
        _validationResult = validation;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnack(context, message: 'Parse Error: $e'),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isParsing = false;
        });
      }
    }
  }

  Future<void> _simulateSave() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final result = await _processUseCase(
        sender: _senderController.text,
        body: _bodyController.text,
        timestampMillis: DateTime.now().millisecondsSinceEpoch,
        showNotification: true,
      );

      setState(() {
        _processResult = result;
      });

      if (!mounted) return;

      if (result.isSuccess) {
        // Reload transactions in provider
        final provider =
            Provider.of<TransactionProvider>(context, listen: false);
        await provider.loadTransactions();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          customSnack(context,
              message:
                  'Success: Transaction recorded in Hive & provider updated!'),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnack(context,
              message:
                  '${result.status.name.toUpperCase()}: ${result.message}'),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnack(context, message: 'Process Error: $e'),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Parser [DEBUG]'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Presets selector
              Text(
                'Sample SMS Presets:',
                style: AppTextTheme.poppins(
                    fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _samplePresets.map((preset) {
                    return Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: ActionChip(
                        label: Text(preset['label']!),
                        onPressed: () {
                          setState(() {
                            _senderController.text = preset['sender']!;
                            _bodyController.text = preset['body']!;
                            _parseResult = null;
                            _validationResult = null;
                            _processResult = null;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 2.h),

              // Sender field
              TextField(
                controller: _senderController,
                decoration: InputDecoration(
                  labelText: 'Sender Address / Header',
                  hintText: 'e.g. VM-HDFCBK',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),

              // Body field
              TextField(
                controller: _bodyController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'SMS Message Body',
                  hintText: 'Paste complete SMS text here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isParsing ? null : _runParse,
                      icon: _isParsing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.analytics_outlined),
                      label: const Text('Parse (Isolate)'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _simulateSave,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: const Text('Simulate Capture'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        backgroundColor: AppColor.mainHexcolor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Results Section
              if (_parseResult != null) ...[
                _buildCandidateBadge(_parseResult!.candidate),
                SizedBox(height: 1.5.h),
                if (_parseResult!.draft != null)
                  _buildDraftDetails(_parseResult!.draft!)
                else
                  _buildRejectedCard(_parseResult!.candidate.rejectionReason),
              ],

              if (_processResult != null) ...[
                SizedBox(height: 2.h),
                _buildProcessStatusCard(_processResult!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateBadge(candidate) {
    final isCandidate = candidate.isCandidate;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isCandidate
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.red.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCandidate ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCandidate ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isCandidate ? Colors.green : Colors.red,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              isCandidate
                  ? 'Candidate Detected: Qualified for transaction parsing'
                  : 'Rejected: ${candidate.rejectionReason ?? 'Not financial'}',
              style: TextStyle(
                color: isCandidate ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedCard(String? reason) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No TransactionDraft generated.',
              style: AppTextTheme.poppins(
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 0.5.h),
            Text(
              reason ??
                  'SMS does not contain actionable debit/credit amounts or patterns.',
              style: AppTextTheme.poppins(
                  fontSize: 12.sp, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftDetails(TransactionDraft draft) {
    final isExpense = draft.type.toLowerCase() == 'expense';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extracted TransactionDraft',
                  style: AppTextTheme.poppins(
                      fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isExpense
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    draft.type.toUpperCase(),
                    style: TextStyle(
                      color: isExpense ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _infoRow('Amount', '₹${draft.amount.toStringAsFixed(2)}'),
            _infoRow('Merchant / Entity', draft.merchant ?? 'N/A'),
            _infoRow('Category', draft.category),
            _infoRow('Payment Method', draft.paymentMethod ?? 'N/A'),
            _infoRow('Reference ID', draft.referenceId ?? 'N/A'),
            _infoRow('Confidence', '${(draft.confidence * 100).toInt()}%'),
            _infoRow('Source Hash', draft.sourceHash),
            if (_validationResult != null) ...[
              const Divider(height: 20),
              _infoRow(
                'Validator Status',
                _validationResult!.isValid ? 'VALID' : 'INVALID',
                valueColor:
                    _validationResult!.isValid ? Colors.green : Colors.red,
              ),
              if (!_validationResult!.isValid)
                _infoRow('Error', _validationResult!.errorMessage ?? ''),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProcessStatusCard(ProcessSmsResult result) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: result.isSuccess
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: result.isSuccess ? Colors.green : Colors.amber,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isSuccess ? Icons.check_circle : Icons.info_outline,
                color: result.isSuccess ? Colors.green : Colors.amber.shade800,
              ),
              SizedBox(width: 2.w),
              Text(
                'Pipeline Status: ${result.status.name.toUpperCase()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      result.isSuccess ? Colors.green : Colors.amber.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.8.h),
          Text(result.message ?? ''),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32.w,
            child: Text(
              label,
              style: AppTextTheme.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextTheme.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
