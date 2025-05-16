import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';


class AppTextStyles {
  static TextStyle? roboto24BoldGreen(context) {
    return GoogleFonts.robotoSlab(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: HexColor("#438883"));
  }
}
