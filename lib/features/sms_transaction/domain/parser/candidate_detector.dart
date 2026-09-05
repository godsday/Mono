import '../entities/transaction_candidate.dart';

class CandidateDetector {
  // Negative patterns (Reject immediately)
  static final RegExp _otpPattern = RegExp(
    r'\b(?:otp|one[- ]?time[- ]?password|verification\s*code|security\s*code|secret\s*code|auth\s*code|v[-]?code|do\s*not\s*share|don\x27t\s*share|valid\s*for\s*\d+\s*min)\b',
    caseSensitive: false,
  );

  static final RegExp _promoPattern = RegExp(
    r'\b(?:congratulations|congrats|pre[- ]?approved|apply\s*now|click\s*here|win\s*up\s*to|special\s*offer|cashback\s*offer|flat\s*\d+%\s*off|voucher|lucky\s*winner|claim\s*your|avail\s*loan|instant\s*loan|disbursed\s*to\s*apply|loan\s*upto|is\s*now\s*ready|personal\s*loan)\b',
    caseSensitive: false,
  );

  static final RegExp _deliveryPattern = RegExp(
    r'\b(?:out\s*for\s*delivery|order\s*placed|package\s*delivered|item\s*dispatched|shipment\s*(?:arrived|departed)|tracking\s*id|appointment\s*(?:scheduled|confirmed))\b',
    caseSensitive: false,
  );

  static final RegExp _duePattern = RegExp(
    r'\b(?:is\s*due\s*on|due\s*on|minimum\s*amount\s*due|min\s*due|total\s*due|payment\s*of.*is\s*due|outstanding\s*amount)\b',
    caseSensitive: false,
  );

  // Positive trigger patterns (Financial keywords)
  static final RegExp _financialActionPattern = RegExp(
    r'\b(?:debit|debited|credit|credited|transaction|transferred|payment|paid|purchase|spent|withdrawn|withdrawal|deposited|sent|received|spent\s+on)\b',
    caseSensitive: false,
  );

  static final RegExp _financialInstrumentPattern = RegExp(
    r'\b(?:UPI|IMPS|NEFT|RTGS|POS|ATM|VPA|A\/c|Acct|Account|Card|Credit\s*Card|Debit\s*Card)\b',
    caseSensitive: false,
  );

  static final RegExp _currencyPattern = RegExp(
    r'(?:INR|Rs\.?|₹)\s*[\d,]+(?:\.\d+)?|[\d,]+(?:\.\d+)?\s*(?:INR|Rs\.?|₹)',
    caseSensitive: false,
  );

  static final RegExp _implicitCurrencyPattern = RegExp(
    r'(?:debited|credited|withdrawn|paid|spent)\s*(?:by|of|for|an\s+amount\s+of)?\s*[\d,]+(?:\.\d{1,2})?',
    caseSensitive: false,
  );

  /// Analyzes an incoming SMS and determines whether it qualifies as a financial candidate.
  TransactionCandidate detect({
    required String sender,
    required String body,
    required DateTime timestamp,
  }) {
    final cleanBody = body.trim();
    if (cleanBody.isEmpty) {
      return TransactionCandidate(
        isCandidate: false,
        rejectionReason: 'Empty message body',
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
    }

    // 1. Check for OTP / verification codes
    if (_otpPattern.hasMatch(cleanBody)) {
      return TransactionCandidate(
        isCandidate: false,
        rejectionReason: 'OTP / Verification SMS detected',
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
    }

    // 2. Check for Promotional SMS
    if (_promoPattern.hasMatch(cleanBody) && !_hasStrongDebitOrCredit(cleanBody)) {
      return TransactionCandidate(
        isCandidate: false,
        rejectionReason: 'Promotional / Marketing SMS detected',
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
    }

    // 3. Check for Delivery / Order status SMS
    if (_deliveryPattern.hasMatch(cleanBody) && !_hasStrongDebitOrCredit(cleanBody)) {
      return TransactionCandidate(
        isCandidate: false,
        rejectionReason: 'Delivery / Order tracking SMS detected',
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
    }

    // 4. Check for Bill Due reminders
    if (_duePattern.hasMatch(cleanBody) && !_hasStrongDebitOrCredit(cleanBody)) {
      return TransactionCandidate(
        isCandidate: false,
        rejectionReason: 'Bill due reminder SMS detected',
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
    }

    // 5. Validate Financial Triggers
    final hasAction = _financialActionPattern.hasMatch(cleanBody);
    final hasCurrency = _currencyPattern.hasMatch(cleanBody) || _implicitCurrencyPattern.hasMatch(cleanBody);
    final hasInstrument = _financialInstrumentPattern.hasMatch(cleanBody);

    if (hasAction && hasCurrency) {
      return TransactionCandidate(
        isCandidate: true,
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
    }

    if (hasInstrument && hasCurrency && _hasImplicitFinancialMovement(cleanBody)) {
      return TransactionCandidate(
        isCandidate: true,
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
    }

    return TransactionCandidate(
      isCandidate: false,
      rejectionReason: 'Does not contain required financial transaction patterns',
      sender: sender,
      body: body,
      timestamp: timestamp,
    );
  }

  static bool _hasStrongDebitOrCredit(String text) {
    final lower = text.toLowerCase();
    return lower.contains('debited') ||
        lower.contains('credited') ||
        lower.contains('withdrawn') ||
        lower.contains('paid rs') ||
        lower.contains('paid inr') ||
        lower.contains('paid ₹') ||
        lower.contains('spent rs') ||
        lower.contains('spent inr') ||
        lower.contains('spent ₹');
  }

  static bool _hasImplicitFinancialMovement(String text) {
    final lower = text.toLowerCase();
    return lower.contains('sent to') ||
        lower.contains('received from') ||
        lower.contains('transfer to') ||
        lower.contains('transferred to') ||
        lower.contains('charged');
  }
}
