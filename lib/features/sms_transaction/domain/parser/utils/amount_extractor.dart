class AmountExtractionResult {
  final double amount;
  final String rawAmountString;
  final double? availableBalance;

  const AmountExtractionResult({
    required this.amount,
    required this.rawAmountString,
    this.availableBalance,
  });
}

class AmountExtractor {
  // Regex to match and isolate Balance snippets so they aren't parsed as transaction amounts
  static final RegExp _balancePattern = RegExp(
    r'(?:avail(?:able)?\s*(?:bal(?:ance)?|limit|lmt)|bal(?:ance)?|total\s*(?:bal(?:ance)?|limit)|avl\s*(?:bal|lmt|limit)|clg\s*bal|clr\s*bal|ac\s*bal|limit|cr\s*limit)\s*(?:is|:|-)?\s*(?:(?:I?NR|Rs\.?|₹)\s*)?([\d,]+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  // Regex patterns targeting transaction amount directly attached to action keywords
  static final List<RegExp> _actionAmountPatterns = [
    // "debited by INR 450", "credited with Rs. 50,000", "paid INR 850"
    RegExp(
      r'(?:debited|credited|paid|spent|withdrawn|transferred|charged|sent|received|purchase\s+of|payment\s+of)\s*(?:by|of|for|amounting\s+to|an\s+amount\s+of|with)?\s*(?:(?:I?NR|Rs\.?|₹)\s*)?([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ),
    // "INR 450 debited", "Rs 50,000 credited", "₹850 paid", "Rs. 2000 withdrawn"
    RegExp(
      r'(?:(?:I?NR|Rs\.?|₹)\s*)([\d,]+(?:\.\d{1,2})?)\s*(?:has\s+been\s+)?(?:debited|credited|paid|spent|withdrawn|transferred|charged|deducted|received)',
      caseSensitive: false,
    ),
    // "debited by 450.00", "credited with 50000.00" (no currency prefix immediately adjacent)
    RegExp(
      r'(?:debited|credited|withdrawn|paid|spent)\s*(?:by|of|for|an\s+amount\s+of)?\s*([\d,]+(?:\.\d{1,2})?)\s*(?:I?NR|Rs\.?|₹)?',
      caseSensitive: false,
    ),
    // Standard currency amount: "INR 450.00", "Rs. 850", "₹450"
    RegExp(
      r'(?:I?NR|Rs\.?|₹)\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    ),
  ];

  /// Extracts the transaction amount and optional available balance from SMS body.
  static AmountExtractionResult? extract(String text) {
    if (text.isEmpty) return null;

    double? extractedBalance;
    final balanceMatch = _balancePattern.firstMatch(text);
    if (balanceMatch != null) {
      final balStr = balanceMatch.group(1)?.replaceAll(',', '');
      if (balStr != null) {
        extractedBalance = double.tryParse(balStr);
      }
    }

    // Create a sanitized text mask where balance substring is blanked out
    // so we don't accidentally pick up the balance as the transaction amount.
    String textWithoutBalance = text;
    if (balanceMatch != null) {
      final start = balanceMatch.start;
      final end = balanceMatch.end;
      textWithoutBalance = '${text.substring(0, start)} ${text.substring(end)}';
    }


    // Try each action-amount pattern in order of specificity
    for (final pattern in _actionAmountPatterns) {
      final matches = pattern.allMatches(textWithoutBalance);
      for (final match in matches) {
        final rawNum = match.group(1)?.replaceAll(',', '').trim();
        if (rawNum != null && rawNum.isNotEmpty) {
          final parsed = double.tryParse(rawNum);
          if (parsed != null && parsed > 0) {
            // Avoid extracting a year like 2024 or an account number ending like 1234
            // if it matched a loose pattern without currency
            return AmountExtractionResult(
              amount: parsed,
              rawAmountString: match.group(0) ?? rawNum,
              availableBalance: extractedBalance,
            );
          }
        }
      }
    }

    // Fallback: If no match on masked text, try standard currency on original text
    final genericCurrencyMatch = RegExp(r'(?:INR|Rs\.?|₹)\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false)
        .firstMatch(text);
    if (genericCurrencyMatch != null) {
      final rawNum = genericCurrencyMatch.group(1)?.replaceAll(',', '').trim();
      if (rawNum != null && rawNum.isNotEmpty) {
        final parsed = double.tryParse(rawNum);
        if (parsed != null && parsed > 0) {
          return AmountExtractionResult(
            amount: parsed,
            rawAmountString: genericCurrencyMatch.group(0) ?? rawNum,
            availableBalance: extractedBalance,
          );
        }
      }
    }

    return null;
  }
}
