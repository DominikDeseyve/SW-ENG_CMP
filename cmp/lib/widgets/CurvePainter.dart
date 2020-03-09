import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  double _a;
  double _b;
  double _c;
  Color _color;

  CurvePainter(Color pColor, double pA, double pB, double pC) {
    this._a = pA;
    this._b = pB;
    this._c = pC;
    this._color = pColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = _color;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * _a); //A
    path.quadraticBezierTo(
        size.width / 2,
        size.height * _b, //B
        size.width,
        size.height * _c); //C
    path.lineTo(size.width, 0); //D
    path.lineTo(0, 0); //E

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
