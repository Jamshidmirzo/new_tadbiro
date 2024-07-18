import 'package:flutter/material.dart';

class LogoPainter extends CustomPainter {
  final double progress;

  LogoPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final textPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.2);


    final textStyle = const TextStyle(
      color: Colors.orange,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(text: 'Tadbiro', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(size.width * 0.3, size.height * 0.6);
    textPainter.paint(canvas, textOffset);

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final extractPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
