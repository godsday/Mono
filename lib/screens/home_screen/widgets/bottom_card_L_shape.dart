import 'package:flutter/material.dart';
import 'package:mono/screens/home_screen/widgets/shapes/curveshape_L_card.dart';
import 'package:sizer/sizer.dart';

// class LShapeWidget extends StatelessWidget {
//   final LShapeOrientation orientation;

//   const LShapeWidget({super.key, required this.orientation});

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: UnifiedCurvedLShapeClipper(
//         verticalLegWidth: 132.0, // Width of the L's vertical arm
//         horizontalBaseHeight: 40.0, // Height of the L's horizontal arm
//         cornerRadius: 60.sp,
//         orientation: orientation,
//         innerCornerRadius: 80,
//       ),
//       child: Container(
//         width: 43.5.w, // Total width of the widget containing the L
//         height: MediaQuery.of(context).size.height /
//             4.5, // Total height of the widget containing the L
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 222, 234, 244),
//         ),
//       ),
//     );
//   }
// }

class LShapeWidget extends StatelessWidget {
  final LShapeOrientation orientation;
  final Color color;

  const LShapeWidget(
      {super.key, required this.orientation, required this.color});

  @override
  Widget build(BuildContext context) {
    final double totalWidth = 43.5.w;
    final double totalHeight = MediaQuery.of(context).size.height / 4.5;

    return ClipPath(
      clipper: UnifiedCurvedLShapeClipper(
        verticalLegWidth: 132.0,
        horizontalBaseHeight: 40.0,
        cornerRadius: 60.sp,
        innerCornerRadius: 80,
        orientation: orientation,
      ),
      child: SizedBox(
        width: totalWidth,
        height: totalHeight,
        child: Stack(
          children: [
            /// Bottom (Main Content) - Green Section
            Positioned.fill(
              child: Container(
                color: color,
              ),
            ),

            /// Top Header - White with Border
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: totalHeight * 0.25, // Adjust height of header
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Header Title",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange,
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
