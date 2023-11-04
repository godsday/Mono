import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class HeadingMethod extends StatelessWidget {
  String headtext;
  String? amount;
  HeadingMethod({
    Key? key,
    required this.headtext,
     this.amount=''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          headtext,
          style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
        Text(
          amount!,
          style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        )
      ],
    );
    
  }
}