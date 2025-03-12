import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class CircularArea extends Layer {
  Offset point;
  double radius = 20;
  Color color = Colors.blue;
  bool isAnimating = false;

  CircularArea.fromTool({required this.point}) : super.fromTool();

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawCircle(
        toCanvas(point),
        radius,
        Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke
          ..color = color);

    canvas.drawCircle(
        toCanvas(point),
        radius,
        Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.fill
          ..color = color.withAlpha(100));
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointInCircularRegion(
        details.localPosition, toCanvas(point), radius)) {
      return this;
    }
    return super.onTapDown(details: details);
  }

  @override
  void onScaleUpdate({required ScaleUpdateDetails details}) {
    point = Offset(toXInverse(details.localFocalPoint.dx),
        toYInverse(details.localFocalPoint.dy).clamp(yMinValue, yMaxValue));
  }

  @override
  void onAimationUpdate(
      {required Canvas canvas, required double animationValue}) {
    if (animationValue != 1) {
      isAnimating = true;
      canvas.drawCircle(
          toCanvas(point),
          radius * animationValue,
          Paint()
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke
            ..color = Colors.red);

      canvas.drawCircle(
          toCanvas(point),
          radius * animationValue,
          Paint()
            ..strokeWidth = 1
            ..style = PaintingStyle.fill
            ..color = color.withAlpha(100));
    } else {
      isAnimating = false;
    }
  }
}
