import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle? roboto22w800Green(context) {
    return GoogleFonts.robotoSlab(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: HexColor("#438883"));
  }

  static TextStyle? roboto15w400grey(context) {
    return GoogleFonts.robotoSlab(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: HexColor("#5C5A5A"));
  }

  static TextStyle? poppins15w400(context) {
    return GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: HexColor("#5C5A5A"));
  }

  static TextStyle? poppins12w300White(context) {
    return GoogleFonts.poppins(
        fontSize: 12.sp, fontWeight: FontWeight.w300, color: Colors.white);
  }

  static TextStyle? poppins18w500White(context) {
    return GoogleFonts.poppins(
        fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.white);
  }

  static TextStyle? roboto18w600SemiBoldWhite(context) {
    return GoogleFonts.roboto(
        fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white);
  }
}
