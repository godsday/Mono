class MerchantExtractor {
  static final List<RegExp> _merchantPatterns = [
    // "debited ... at AMAZON on 26-Aug"
    RegExp(
      r'\bat\s+([A-Za-z0-9\s._\-&]{2,30}?)(?:\.|\s+on\b|\s+via\b|\s+ref\b|\s+avl\b|\s+bal\b|\s+using\b|\s+dated\b|$)',
      caseSensitive: false,
    ),
    // "payment of Rs 850 to SWIGGY" / "transferred to JOHN"
    RegExp(
      r'\bto\s+(?:VPA\s+)?([A-Za-z0-9\s._\-&@]{2,30}?)(?:\.|\s+on\b|\s+via\b|\s+ref\b|\s+avl\b|\s+bal\b|\s+using\b|\s+dated\b|$)',
      caseSensitive: false,
    ),
    // "credited ... towards salary"
    RegExp(
      r'\btowards\s+([A-Za-z0-9\s._\-&]{2,30}?)(?:\.|\s+on\b|\s+via\b|\s+ref\b|\s+avl\b|\s+bal\b|\s+using\b|\s+dated\b|$)',
      caseSensitive: false,
    ),
    // "credited from ABC CORP"
    RegExp(
      r'\bfrom\s+(?:VPA\s+)?([A-Za-z0-9\s._\-&@]{2,30}?)(?:\.|\s+on\b|\s+via\b|\s+ref\b|\s+avl\b|\s+bal\b|\s+using\b|\s+dated\b|$)',
      caseSensitive: false,
    ),
    // "Info: SWIGGY*123" / "Info: AMAZON PAY"
    RegExp(
      r'\bInfo[:\s]+([A-Za-z0-9\s._\-&]{2,30}?)(?:\.|\s+on\b|\s+via\b|\s+ref\b|\s+avl\b|\s+bal\b|$|\*)',
      caseSensitive: false,
    ),
    // "withdrawn from ATM XYZ"
    RegExp(
      r'\bfrom\s+(ATM(?:\s+[A-Za-z0-9\-_]+)?)(?:\.|\s+on\b|\s+via\b|\s+ref\b|\s+avl\b|\s+bal\b|$)',
      caseSensitive: false,
    ),
  ];

  static final List<String> _blacklistWords = [
    'your account',
    'your a/c',
    'a/c',
    'account',
    'my account',
    'bank',
    'upi',
    'imps',
    'neft',
    'rtgs',
    'card',
    'debit card',
    'credit card',
  ];

  /// Extracts the merchant / counterparty name from text.
  static String? extract(String text) {
    if (text.isEmpty) return null;

    // Check ATM withdrawal first
    if (RegExp(r'\b(?:ATM|cash\s*withdrawal)\b', caseSensitive: false).hasMatch(text) &&
        RegExp(r'\bwithdrawn\b', caseSensitive: false).hasMatch(text)) {
      return 'ATM Withdrawal';
    }

    for (final pattern in _merchantPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        var raw = match.group(1)?.trim();
        if (raw != null && raw.isNotEmpty) {
          raw = _cleanMerchant(raw);
          if (raw != null && raw.isNotEmpty && !_isBlacklisted(raw)) {
            return raw;
          }
        }
      }
    }

    // Direct check for salary
    if (RegExp(r'\bsalary\b', caseSensitive: false).hasMatch(text)) {
      return 'Salary';
    }

    return null;
  }

  static String? _cleanMerchant(String input) {
    var cleaned = input
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(RegExp(r'^[_\-.\s]+|[_\-.\s]+$'), '')
        .trim();

    // If it is a VPA like name@bank, extract the name portion
    if (cleaned.contains('@')) {
      final parts = cleaned.split('@');
      if (parts.isNotEmpty && parts[0].length >= 2) {
        cleaned = parts[0].replaceAll(RegExp(r'[._\-]'), ' ').trim();
      }
    }

    if (cleaned.length < 2 || cleaned.length > 35) return null;
    return cleaned;
  }

  static bool _isBlacklisted(String candidate) {
    final lower = candidate.toLowerCase().trim();
    return _blacklistWords.contains(lower) ||
        lower.startsWith('your a/c') ||
        lower.startsWith('a/c');
  }
}
