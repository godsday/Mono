import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';

class AppTextStyles {
  static TextStyle? roboto22w800Green(context) {
    return GoogleFonts.robotoSlab(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: AppColor.greenText);
  }

  static TextStyle? roboto15w400grey(context) {
    return GoogleFonts.robotoSlab(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.darkGreyText);
  }

  static TextStyle? poppins15w400(context) {
    return GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColor.darkGreyText);
  }

  static TextStyle? poppins12w300White(context) {
    return GoogleFonts.poppins(
        fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColor.white);
  }

  static TextStyle? poppins18w500White(context) {
    return GoogleFonts.poppins(
        fontSize: 18.sp, fontWeight: FontWeight.w500, color: AppColor.white);
  }

  static TextStyle? roboto18w600SemiBoldWhite(context) {
    return GoogleFonts.roboto(
        fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColor.white);
  }

  static TextStyle roboto16w600Black = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColor.blackText,
  );

  static TextStyle poppins16w400 = AppTextTheme.poppins(
    fontSize: 16.sp,
    color: AppColor.textSecondary,
    fontWeight: FontWeight.w400,
  );
  static TextStyle poppins16w600 = AppTextTheme.poppins(
    fontSize: 16.sp,
    color: AppColor.blackText,
    fontWeight: FontWeight.w600,
  );
  static TextStyle montserrat18w600 = AppTextTheme.montserrart(
    fontSize: 18.sp,
    color: AppColor.textSecondary,
    fontWeight: FontWeight.w600,
  );
  static TextStyle poppins18w600 = AppTextTheme.poppins(
    fontSize: 18.sp,
    color: AppColor.textSecondary,
    fontWeight: FontWeight.w600,
  );
}
