import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 15.h,
              decoration: BoxDecoration(
                gradient: Theme.of(context)
                    .extension<AppGradients>()!
                    .primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Hub',
                      style: AppTextTheme.montserrart(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Your Budget, Assets & Dreams — all in one place',
                      style: AppTextTheme.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0.3.h,
          right: 3,
          child: Image(
            width: 50.w,
            image: const AssetImage(
              'assets/images/rings.png',
            ),
          ),
        )
      ],
    );
  }
}
