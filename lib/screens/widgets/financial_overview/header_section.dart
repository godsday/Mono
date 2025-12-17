import 'package:flutter/material.dart';
import 'package:mono/constants/colors/app_color.dart';
import 'package:mono/constants/utils/app_texttheme.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Hub',
          style: AppTextTheme.montserrart(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColor.mainHexcolor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your Budget, Assets & Dreams — all in one place',
          style: AppTextTheme.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.mainHexcolor,
                AppColor.accentHexColor,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}