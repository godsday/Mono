import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firststart = Offset(size.width / 6.29, size.height);
    var firstend = Offset(size.width / 1.65, size.height - 35.0);
    path.quadraticBezierTo(
        firststart.dx, firststart.dy, firstend.dx, firstend.dy);
    //path.lineTo(size.width/2.25, size.height);
    var secondstart =
        Offset(size.width - (size.width / 6.29), size.height - 50.0);
    var secondend = Offset(size.width, size.height - 4);
    path.quadraticBezierTo(
        secondstart.dx, secondstart.dy, secondend.dx, secondend.dy);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
