// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get welcome => 'नमस्ते, स्वागत है!';

  @override
  String get total_balance => 'कुल शेष';

  @override
  String get currency_symbol => '₹';

  @override
  String get onboarding_title => 'समझदारी से खर्च करें, अधिक बचत करें';

  @override
  String get onboarding_subtitle =>
      'शक्तिशाली ट्रैकिंग और नियोजन उपकरणों के साथ अपने पैसे पर नियंत्रण रखें';

  @override
  String get enter_name_hint => 'उपनाम';

  @override
  String get get_started => 'शुरू करें';

  @override
  String get select_language => 'भाषा चुनें';
}
