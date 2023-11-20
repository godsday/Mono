import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Baxkbutton extends StatelessWidget {
  const Baxkbutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 4.2.h,
        height: 4.2.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7), color: Colors.white70),
        child: Icon(
          Icons.arrow_back_ios,
          size: 13.sp,
        ));
  }
}
