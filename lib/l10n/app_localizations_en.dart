// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Hi, Welcome!';

  @override
  String get total_balance => 'Total Balance';

  @override
  String get currency_symbol => '₹';

  @override
  String get onboarding_title => 'Spend Smarter Save More';

  @override
  String get onboarding_subtitle =>
      'Take control of your money with powerful tracking and planning tools';

  @override
  String get enter_name_hint => 'Nickname';

  @override
  String get get_started => 'Get Started';

  @override
  String get select_language => 'Select Language';
}
