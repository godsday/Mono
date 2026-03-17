import 'package:flutter/material.dart';

class AppTextTheme {
  static const String fontFamilyPoppins = 'Poppins';
  static const String fontFamilyMontserrat = 'Montserrat';
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilyRobotoSlab = 'RobotoSlab';

  // Headings
  static TextStyle heading1 = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle heading2 = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static TextStyle heading3 = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Body text
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Buttons
  static TextStyle buttonLarge = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle buttonMedium = const TextStyle(
    fontFamily: fontFamilyPoppins,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // Special cases for other font families
  static TextStyle montserratExtraBold = const TextStyle(
    fontFamily: fontFamilyMontserrat,
    fontWeight: FontWeight.w800,
  );

  static TextStyle montserratMedium = const TextStyle(
    fontFamily: fontFamilyMontserrat,
    fontWeight: FontWeight.w500,
  );

  static TextStyle inter = const TextStyle(
    fontFamily: fontFamilyInter,
    fontWeight: FontWeight.w400,
  );

  // Helper method to create text styles with overrides
  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    FontStyle fontsStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamilyPoppins,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  static TextStyle montserrart({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    FontStyle fontsStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: AppTextTheme.fontFamilyMontserrat,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  static TextStyle robotoSlab({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    FontStyle fontsStyle = FontStyle.normal,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamilyRobotoSlab,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }
}
