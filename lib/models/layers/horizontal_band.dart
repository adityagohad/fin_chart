import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class HorizontalBand extends Layer {
  double value;
  double allowedError;

  HorizontalBand.fromTool({required this.value, this.allowedError = 40})
      : super.fromTool();

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawRect(
        Rect.fromLTWH(leftPos, toY(value) - allowedError / 2,
            rightPos - leftPos, allowedError),
        Paint()
          ..color = Colors.blue.withAlpha(100)
          ..strokeWidth = 2);
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointOnLine(details.localPosition, Offset(leftPos, toY(value)),
        Offset(rightPos, toY(value)))) {
      return this;
    }
    return super.onTapDown(details: details);
  }

  @override
  void onScaleUpdate({required ScaleUpdateDetails details}) {
    value = toYInverse(toY(value) + details.focalPointDelta.dy);
  }
}
