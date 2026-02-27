import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomSlant; // horizontal inset at bottom from the right edge

  const CustomShapeClipper({
    this.topLeftRadius = 20.0,
    this.topRightRadius = 6.0,
    this.bottomSlant = 24.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start after top-left curve
    path.moveTo(topLeftRadius, 0);

    // Top edge (ends before top-right curve)
    path.lineTo(size.width - topRightRadius, 0);

    // Top-right curve (radius topRightRadius)
    path.quadraticBezierTo(
      size.width,
      0,
      size.width,
      topRightRadius,
    );

    // Right slanted edge (from top-right curve to bottom inset)
    path.lineTo(size.width - bottomSlant, size.height);

    // Bottom edge (horizontal)
    path.lineTo(0, size.height);

    // Left edge (vertical, sharp bottom-left corner)
    path.lineTo(0, topLeftRadius);

    // Top-left curve (radius topLeftRadius)
    path.quadraticBezierTo(
      0,
      0,
      topLeftRadius,
      0,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomShapeClipper oldClipper) {
    return oldClipper.topLeftRadius != topLeftRadius ||
        oldClipper.topRightRadius != topRightRadius ||
        oldClipper.bottomSlant != bottomSlant;
  }
}
