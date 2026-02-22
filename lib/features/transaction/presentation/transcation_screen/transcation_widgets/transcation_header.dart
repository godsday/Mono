import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/features/widgets/add_clipper.dart';
import 'package:sizer/sizer.dart';

class TranscationHeader extends StatelessWidget {
  const TranscationHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: CurveClipper(),
          child: Container(
            height: 15.0.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF429690), Color(0xFF1E4744)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Recent Transactions",
                style: AppTextTheme.montserrart(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColor.white,
                ),
              ),
            ),
          ),
        ),
        const Positioned(
            top: 2,
            child: Image(
              image: AssetImage(
                'assets/images/rings.png',
              ),
            )),
      ],
    );
  }
}
