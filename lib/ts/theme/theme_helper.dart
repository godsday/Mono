import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../core/utils/pref_utils.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = PrefUtils().getThemeData();

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get black => Color(0xFF1E1E1E);
  Color get white => Color(0xFFFFFFFF);
  Color get gray100 => Color(0xFFF3F4F6);
  Color get gray600 => Color(0xFF4B5563);
  Color get gray500 => Color(0xFF6B7280);
  Color get gray800 => Color(0xFF1F2937);
  Color get red500 => Color(0xFFEF4444);
  Color get gray200 => Color(0xFFE5E7EB);
  Color get gray700 => Color(0xFF374151);

  // Additional Colors
  Color get greyCustom => Colors.grey;
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get transparentCustom => Colors.transparent;
  Color get blueCustom => Colors.blue;
  Color get colorFF81B2 => Color(0xFF81B2CA);
  Color get colorFF836F => Color(0xFF836F81);
  Color get colorFF4288 => Color(0xFF42887C);
  Color get colorFF14B8 => Color(0xFF14B8A6);
  Color get colorFF0D94 => Color(0xFF0D9488);
  Color get colorFF6B72 => Color(0xFF6B7280);
  Color get colorFFDCF0 => Color(0xFFDCF0F5);
  Color get colorFFF3F4 => Color(0xFFF3F4F6);
  Color get colorFF1F29 => Color(0xFF1F2937);
  Color get colorFFE5E7 => Color(0xFFE5E7EB);
  Color get colorFF3741 => Color(0xFF374151);
  Color get colorFFEF44 => Color(0xFFEF4444);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
  Color get grey600 => Colors.grey.shade600;
  Color get grey700 => Colors.grey.shade700;
}
