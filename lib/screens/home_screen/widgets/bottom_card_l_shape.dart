import 'package:flutter/material.dart';
import 'package:mono/screens/home_screen/widgets/shapes/curveshape_l_card.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:mono/models/top_category_model.dart';

class LShapeWidget extends StatelessWidget {
  final LShapeOrientation orientation;
  final Color color;
  final String type;
  final IconData icons;
  final List<TopCategory> categories;
  final double totalAmount;

  const LShapeWidget(
      {super.key,
      required this.orientation,
      required this.color,
      required this.type,
      required this.icons,
      required this.categories,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final double totalWidth = 43.5.w;
    final double totalHeight = MediaQuery.of(context).size.height / 4.8;

    return ClipPath(
      clipper: UnifiedCurvedLShapeClipper(
        verticalLegWidth: 36.9.w,
        horizontalBaseHeight: 6.0.h,
        cornerRadius: 12.sp,
        innerCornerRadius: 30.sp,
        orientation: orientation,
      ),
      child: SizedBox(
        width: totalWidth,
        height: totalHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: color,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 3.w,
                right: 3.w,
                height: totalHeight * 0.76, // Adjust height of content area
                child: orientation == LShapeOrientation.leftLegOnLeft
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type == 'Income' ? 'Top Earning' : 'Top Spending',
                            style: AppTextStyles.poppins12w300White(context)
                                ?.copyWith(
                              color: type == 'Income'
                                  ? HexColor('#49ABF2')
                                  : HexColor('#FF0000'),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 12.sp),

                          // Display top categories dynamically
                          ...categories.asMap().entries.take(2).map((entry) {
                            int idx = entry.key;
                            TopCategory category = entry.value;
                            return Column(
                              crossAxisAlignment:
                                  orientation == LShapeOrientation.leftLegOnLeft
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${category.name} - ${category.percentage.toStringAsFixed(0)}%',
                                  style:
                                      AppTextStyles.poppins12w300White(context)
                                          ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 7.sp),
                                SizedBox(
                                  width: totalWidth * 0.3,
                                  child: LinearProgressIndicator(
                                    value: totalAmount > 0
                                        ? (category.amount / totalAmount)
                                        : 0,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        type == 'Income'
                                            ? HexColor('#49ABF2')
                                            : HexColor('#FF0000')),
                                  ),
                                ),
                                if (idx < 1) SizedBox(height: 12.sp),
                              ],
                            );
                          }),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            type == 'Income' ? 'Top Earning' : 'Top Spending',
                            style: AppTextStyles.poppins12w300White(context)
                                ?.copyWith(
                              color: type == 'Income'
                                  ? HexColor('#49ABF2')
                                  : HexColor('#FF0000'),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 12.sp),

                          // Display top categories dynamically
                          ...categories.asMap().entries.take(2).map((entry) {
                            int idx = entry.key;
                            TopCategory category = entry.value;
                            return Column(
                              crossAxisAlignment:
                                  orientation == LShapeOrientation.leftLegOnLeft
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${category.name} - ${category.percentage.toStringAsFixed(0)}%',
                                  style:
                                      AppTextStyles.poppins12w300White(context)
                                          ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 7.sp),
                                SizedBox(
                                  width: totalWidth * 0.3,
                                  child: LinearProgressIndicator(
                                    value: totalAmount > 0
                                        ? (category.amount / totalAmount)
                                        : 0,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        type == 'Income'
                                            ? HexColor('#49ABF2')
                                            : HexColor('#FF0000')),
                                  ),
                                ),
                                if (idx < 1) SizedBox(height: 12.sp),
                              ],
                            );
                          }),
                        ],
                      )),
            Positioned(
              bottom: -21.sp,
              left: orientation == LShapeOrientation.leftLegOnLeft ? -3.w : 0.w,
              right: 0,
              height: totalHeight * 0.76, // Adjust height of content area
              child: const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),

            Positioned(
              bottom: -24.sp,
              left:
                  orientation == LShapeOrientation.leftLegOnLeft ? 3.5.w : 16.w,
              right: 0,
              height: totalHeight * 0.04.h, // Adjust height of content area
              child: Text(
                '₹ ${totalAmount.toStringAsFixed(1)}',
                style: AppTextStyles.poppins18w500White(context)
                    ?.copyWith(color: HexColor('#030303')),
              ),
            ),

            /// Top Header - White with Border
            Positioned(
              top: 0,
              left: orientation == LShapeOrientation.leftLegOnLeft ? -1.w : 6.w,
              right: 0,
              height: totalHeight * 0.20, // Adjust height of header
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 246, 246),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#525252'),
                      ),
                    ),
                    SizedBox(
                      width: orientation == LShapeOrientation.leftLegOnLeft
                          ? 14.w
                          : 11.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: orientation == LShapeOrientation.leftLegOnLeft
                              ? HexColor('#42887C')
                              : HexColor('#FF0000'),
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          icons,
                          size: 17.sp,
                          color: color,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
