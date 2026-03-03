import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class DecorationBox extends StatelessWidget {
  final double width;
  final double height;
  const DecorationBox({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: -45 * 3.1415927 / 180,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                HexColor('#352C80').withValues(alpha: 0.20),
                HexColor('#9995AF').withValues(alpha: 0.0),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ));
  }
}
