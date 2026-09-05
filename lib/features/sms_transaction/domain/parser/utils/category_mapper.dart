class CategoryMapper {
  // Expense keyword maps
  static final Map<String, List<String>> _expenseKeywords = {
    'Food': [
      'swiggy', 'zomato', 'mcdonald', 'kfc', 'dominos', 'pizza', 'burger',
      'starbucks', 'cafe', 'restaurant', 'food', 'instamart', 'zepto', 'blinkit',
      'bigbasket', 'grofers', 'eats', 'bakery', 'dining', 'dineout', 'dunkin'
    ],
    'Shopping': [
      'amazon', 'flipkart', 'myntra', 'ajio', 'meesho', 'zara', 'h&m', 'nykaa',
      'tata cliq', 'reliance digital', 'croma', 'ikea', 'shopping', 'mall',
      'retail', 'store', 'decathlon', 'uniqlo', 'westside', 'lifestyle'
    ],
    'Travel': [
      'uber', 'ola', 'rapido', 'irctc', 'makemytrip', 'yatra', 'goibibo', 'indigo',
      'air india', 'redbus', 'petrol', 'fuel', 'hpcl', 'bpcl', 'iocl', 'shell',
      'toll', 'fastag', 'metro', 'flight', 'airline', 'cab', 'taxi', 'railway'
    ],
    'Entertainment': [
      'netflix', 'spotify', 'hotstar', 'prime video', 'bookmyshow', 'pvr', 'inox',
      'movie', 'cinema', 'youtube', 'sonyliv', 'zee5', 'apple music', 'disney', 'gaming'
    ],
    'Utilities': [
      'electricity', 'bescom', 'mseb', 'tneb', 'cesc', 'water', 'gas', 'cylinder',
      'indane', 'hp gas', 'bharat gas', 'billdesk', 'recharge', 'jio', 'airtel',
      'vi', 'vodafone', 'broadband', 'act fibernet', 'wifi', 'dth', 'tata play', 'postpaid'
    ],
    'Medical': [
      'apollo', '1mg', 'medplus', 'netmeds', 'pharmacy', 'hospital', 'clinic',
      'diagnostic', 'doctor', 'chemist', 'healthcare', 'pharma', 'dr lal', 'practo'
    ],
    'Education': [
      'school', 'college', 'tuition', 'udemy', 'coursera', 'university', 'fees',
      'academy', 'classes', 'education', 'byjus', 'unacademy'
    ],
    'Insurance': [
      'lic', 'insurance', 'policybazaar', 'hdfc ergo', 'max life', 'star health',
      'icici lombard', 'bajaj allianz', 'premium'
    ],
  };

  // Income keyword maps
  static final Map<String, List<String>> _incomeKeywords = {
    'Salary': ['salary', 'payroll', 'stipend', 'wages', 'employer', 'salary credit'],
    'Rental': ['rent', 'rental', 'tenant'],
    'Gift': ['gift', 'reward', 'cashback', 'bonus'],
  };

  /// Maps an extracted transaction and merchant to one of Mono's categories.
  static String mapCategory({
    required String type,
    String? merchant,
    required String fullBody,
  }) {
    final searchContext = '${merchant ?? ''} $fullBody'.toLowerCase();

    if (type.toLowerCase() == 'income') {
      for (final entry in _incomeKeywords.entries) {
        for (final kw in entry.value) {
          if (searchContext.contains(kw)) {
            return entry.key;
          }
        }
      }
      return 'Credit'; // Default income category in Mono
    } else {
      // Expense
      for (final entry in _expenseKeywords.entries) {
        for (final kw in entry.value) {
          if (searchContext.contains(kw)) {
            return entry.key;
          }
        }
      }
      return 'Debit'; // Default expense category in Mono
    }
  }
}
