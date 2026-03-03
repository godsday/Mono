import 'package:flutter/material.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 1.45);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 1.45);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
