import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, String currencyCode) {
    NumberFormat formatter;

    switch (currencyCode.toUpperCase()) {
      case 'INR':
        formatter = NumberFormat.currency(
          locale: 'en_IN',
          symbol: '₹',
          decimalDigits: 0,
        );
        break;
      case 'EUR':
        formatter = NumberFormat.currency(
          locale: 'en_EU',
          symbol: '€',
          decimalDigits: 0,
        );
        break;
      case 'GBP':
        formatter = NumberFormat.currency(
          locale: 'en_GB',
          symbol: '£',
          decimalDigits: 0,
        );
        break;
      case 'JPY':
        formatter = NumberFormat.currency(
          locale: 'ja_JP',
          symbol: '¥',
          decimalDigits: 0,
        );
        break;
      case 'USD':
      default:
        formatter = NumberFormat.currency(
          locale: 'en_US',
          symbol: '\$',
          decimalDigits: 0,
        );
        break;
    }

    return formatter.format(amount);
  }
}
