import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  static const String _localeKey = 'selected_locale';

  LocaleProvider() {
    _loadLocale();
  }

  void setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  void clearLocale() async {
    _locale = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
}

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('es'),
    const Locale('hi'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'es':
        return '🇪🇸';
      case 'hi':
        return '🇮🇳';
      case 'en':
      default:
        return '🇺🇸';
    }
  }

  static String getLanguageName(String code) {
    switch (code) {
      case 'es':
        return 'Español';
      case 'hi':
        return 'हिन्दी';
      case 'en':
      default:
        return 'English';
    }
  }
}
