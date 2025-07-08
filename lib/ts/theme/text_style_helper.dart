import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  TextStyle get title18SemiBold => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: appTheme.whiteCustom,
      );

  TextStyle get title16SemiBold => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: appTheme.colorFF0D94,
      );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body14Medium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: appTheme.colorFF6B72,
      );

  TextStyle get body14SemiBold => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: appTheme.colorFF6B72,
      );

  TextStyle get body12 =>
      TextStyle(fontSize: 12.sp, color: appTheme.colorFF6B72);

  // Other Styles
  // Miscellaneous text styles without specified font size

  TextStyle get textStyle7 => TextStyle();

  TextStyle get bodyTextPoppins => TextStyle(fontFamily: 'Poppins');
}
