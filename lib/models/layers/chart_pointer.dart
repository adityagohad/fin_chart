import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class ChartPointer extends Layer {
  Offset pointOffset;
  double radius = 5;
  Color color = Colors.blue;
  late Offset startPoint;

  ChartPointer({required this.pointOffset});

  @override
  void drawLayer({required Canvas canvas}) {
    Paint paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawLine(Offset(leftPos, toCanvas(pointOffset).dy),
        Offset(rightPos, toCanvas(pointOffset).dy), paint);
    canvas.drawLine(Offset(toCanvas(pointOffset).dx, topPos),
        Offset(toCanvas(pointOffset).dx, bottomPos), paint);
    canvas.drawCircle(toCanvas(pointOffset), radius, paint);
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointInCircularRegion(
        details.localPosition, toCanvas(pointOffset), radius)) {
      startPoint = pointOffset;
      return this;
    }
    return super.onTapDown(details: details);
  }

  @override
  void onScaleUpdate({required ScaleUpdateDetails details}) {
    pointOffset = move(startPoint, details.localFocalPoint);
  }
}
