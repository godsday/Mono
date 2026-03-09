import 'package:flutter/widgets.dart';
import 'package:mono/l10n/app_localizations.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
