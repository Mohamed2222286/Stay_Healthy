import 'package:flutter/material.dart';
class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height /1.5);
    path.quadraticBezierTo(
      size.width / 1.9,
      size.height,
      size.width,
      size.height /1.5 ,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}