import 'package:flutter/material.dart';

class CurveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Top Y (no padding)
    double topY = 0;

    // Bottom Y values for left and right arms
    double leftArmBottomY = size.height * 0.8;
    double rightArmBottomY = size.height * 0.92;

    // Corner radius for bottom curves
    double cornerRadius = size.width * 0.08;

    // Start from top-left
    path.moveTo(0, topY);

    // Left arm down
    path.lineTo(0, leftArmBottomY - cornerRadius);

    // Bottom-left curve
    path.quadraticBezierTo(
      0, // Control point X
      leftArmBottomY, // Control point Y
      cornerRadius, // End point X
      leftArmBottomY, // End point Y
    );

    // Bottom connecting diagonal
    path.lineTo(size.width - cornerRadius, rightArmBottomY);

    // Bottom-right curve
    path.quadraticBezierTo(
      size.width, // Control X
      rightArmBottomY, // Control Y
      size.width, // End X
      rightArmBottomY - cornerRadius, // End Y
    );

    // Right arm up
    path.lineTo(size.width, topY);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
