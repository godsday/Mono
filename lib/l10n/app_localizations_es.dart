// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome => '¡Hola, bienvenido!';

  @override
  String get total_balance => 'Balance total';

  @override
  String get currency_symbol => '€';

  @override
  String get onboarding_title => 'Gasta con inteligencia, ahorra más';

  @override
  String get onboarding_subtitle =>
      'Toma el control de tu dinero con potentes herramientas de seguimiento y planificación';

  @override
  String get enter_name_hint => 'Apodo';

  @override
  String get get_started => 'Empezar';

  @override
  String get select_language => 'Seleccionar idioma';
}
