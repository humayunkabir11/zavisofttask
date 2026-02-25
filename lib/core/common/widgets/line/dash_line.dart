import 'package:flutter/material.dart';

enum DashLineDirection { vertical, horizontal }

class DashedLine extends StatelessWidget {
  final double length;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double dashHeight; // NEW
  final DashLineDirection direction;

  const DashedLine({
    super.key,
    this.length = 100,
    this.color = Colors.black,
    this.dashWidth = 5,
    this.dashSpace = 5,
    this.dashHeight = 1, // default thickness
    this.direction = DashLineDirection.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: direction == DashLineDirection.vertical ? length : dashHeight,
      width: direction == DashLineDirection.horizontal ? length : dashHeight,
      child: CustomPaint(
        painter: _DashPainter(
          color: color,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          dashHeight: dashHeight,
          direction: direction,
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double dashHeight; // NEW
  final DashLineDirection direction;

  _DashPainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.dashHeight,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashHeight // use thickness
      ..style = PaintingStyle.stroke;

    double start = 0;
    if (direction == DashLineDirection.vertical) {
      while (start < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, start),
          Offset(size.width / 2, start + dashWidth),
          paint,
        );
        start += dashWidth + dashSpace;
      }
    } else {
      while (start < size.width) {
        canvas.drawLine(
          Offset(start, size.height / 2),
          Offset(start + dashWidth, size.height / 2),
          paint,
        );
        start += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) {
    return color != oldDelegate.color ||
        dashWidth != oldDelegate.dashWidth ||
        dashSpace != oldDelegate.dashSpace ||
        dashHeight != oldDelegate.dashHeight ||
        direction != oldDelegate.direction;
  }
}
