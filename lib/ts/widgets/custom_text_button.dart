import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';

/**
 * A customizable text button component that supports various styling options
 * and responsive design. Based on Flutter's TextButton with enhanced customization.
 * 
 * @param text - The text to display on the button
 * @param onPressed - Callback function when button is pressed
 * @param variant - Style variant of the button
 * @param textColor - Color of the button text
 * @param backgroundColor - Background color of the button
 * @param fontSize - Font size of the button text
 * @param fontWeight - Font weight of the button text
 * @param isEnabled - Whether the button is enabled or disabled
 * @param padding - Internal padding of the button
 * @param borderRadius - Border radius of the button
 */
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.isEnabled,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Style variant of the button
  final CustomTextButtonVariant? variant;

  /// Color of the button text
  final Color? textColor;

  /// Background color of the button
  final Color? backgroundColor;

  /// Font size of the button text
  final double? fontSize;

  /// Font weight of the button text
  final FontWeight? fontWeight;

  /// Whether the button is enabled or disabled
  final bool? isEnabled;

  /// Internal padding of the button
  final EdgeInsetsGeometry? padding;

  /// Border radius of the button
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final bool enabled = isEnabled ?? true;
    final CustomTextButtonVariant buttonVariant =
        variant ?? CustomTextButtonVariant.primary;

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: _getButtonStyle(buttonVariant),
      child: Text(text, style: _getTextStyle(buttonVariant)),
    );
  }

  ButtonStyle _getButtonStyle(CustomTextButtonVariant variant) {
    final Color bgColor =
        backgroundColor ?? _getDefaultBackgroundColor(variant);
    final EdgeInsetsGeometry buttonPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.h);
    final double radius = borderRadius ?? 8.h;

    return TextButton.styleFrom(
      backgroundColor: bgColor,
      padding: buttonPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  TextStyle _getTextStyle(CustomTextButtonVariant variant) {
    final Color defaultTextColor = textColor ?? _getDefaultTextColor(variant);
    final double defaultFontSize = fontSize ?? _getDefaultFontSize(variant);
    final FontWeight defaultFontWeight =
        fontWeight ?? _getDefaultFontWeight(variant);

    return TextStyleHelper.instance.bodyTextPoppins;
  }

  Color _getDefaultBackgroundColor(CustomTextButtonVariant variant) {
    switch (variant) {
      case CustomTextButtonVariant.primary:
        return appTheme.transparentCustom;
      case CustomTextButtonVariant.secondary:
        return appTheme.grey100;
      case CustomTextButtonVariant.filled:
        return appTheme.blueCustom;
    }
  }

  Color _getDefaultTextColor(CustomTextButtonVariant variant) {
    switch (variant) {
      case CustomTextButtonVariant.primary:
        return appTheme.grey600;
      case CustomTextButtonVariant.secondary:
        return appTheme.grey700;
      case CustomTextButtonVariant.filled:
        return appTheme.whiteCustom;
    }
  }

  double _getDefaultFontSize(CustomTextButtonVariant variant) {
    switch (variant) {
      case CustomTextButtonVariant.primary:
        return 14;
      case CustomTextButtonVariant.secondary:
        return 14;
      case CustomTextButtonVariant.filled:
        return 16;
    }
  }

  FontWeight _getDefaultFontWeight(CustomTextButtonVariant variant) {
    switch (variant) {
      case CustomTextButtonVariant.primary:
        return FontWeight.w500;
      case CustomTextButtonVariant.secondary:
        return FontWeight.w500;
      case CustomTextButtonVariant.filled:
        return FontWeight.w600;
    }
  }
}

/// Enum defining different variants of the custom text button
enum CustomTextButtonVariant {
  /// Primary variant with transparent background and gray text
  primary,

  /// Secondary variant with light gray background
  secondary,

  /// Filled variant with colored background and white text
  filled,
}
