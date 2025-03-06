import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends Layer {
  double value;

  HorizontalLine({required this.value});

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawLine(
        Offset(leftPos, toY(value)),
        Offset(rightPos, toY(value)),
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2);
  }

  @override
  void drawRightAxisValues({required Canvas canvas}) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(2),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.drawRect(
        Rect.fromLTWH(
            rightPos,
            toY(value) - text.height / 2 - yLabelPadding / 2,
            text.width + 2 * xLabelPadding,
            text.height + yLabelPadding),
        Paint()..color = Colors.blue);

    text.paint(canvas,
        Offset(rightPos + yLabelPadding / 2, toY(value) - text.height / 2));
  }

  @override
  void drawLeftAxisValues({required Canvas canvas}) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(2),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.drawRect(
        Rect.fromLTWH(0, toY(value) - text.height / 2 - yLabelPadding / 2,
            leftPos, text.height + yLabelPadding),
        Paint()..color = Colors.blue);

    text.paint(canvas, Offset(yLabelPadding / 2, toY(value) - text.height / 2));
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
