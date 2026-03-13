import 'package:flutter/widgets.dart';
import 'package:mono/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../features/app_settings/presentation/providers/app_settings_provider.dart';
import '../currency_formatter.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  String formatCurrency(double amount) {
    final appSettings = watch<AppSettingsProvider>();
    return CurrencyFormatter.format(amount, appSettings.currencyCode);
  }

  String get currencySymbol {
    return watch<AppSettingsProvider>().currencySymbol;
  }
}
