import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/widgets/add_clipper.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:sizer/sizer.dart';

class TranscationHeader extends StatelessWidget {
  const TranscationHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            // height: 20.h,
            decoration: BoxDecoration(
              gradient:
                  Theme.of(context).extension<AppGradients>()!.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  Text(
                    context.l10n.recent_transactions,
                    style: AppTextTheme.montserrart(
                      fontSize: 18.5.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ],
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
      ),
    );
  }
}
