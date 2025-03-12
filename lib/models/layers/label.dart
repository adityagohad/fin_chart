import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class Label extends Layer {
  Offset pos;
  String label;
  TextStyle textStyle;
  late double width;
  late double height;
  Label.fromTool(
      {required this.pos, required this.label, required this.textStyle})
      : super.fromTool();
  @override
  void drawLayer({required Canvas canvas}) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: label,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    width = text.width;
    height = text.height;
    //pos = toReal(Offset(toX(pos.dx) - width / 2, toY(pos.dy) - height / 2));
    // print(pos);
    // print(toReal(Offset(toX(pos.dx) - width / 2, toY(pos.dy) - height / 2)));

    text.paint(canvas, toCanvas(pos));
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointNearRectFromDiagonalVertices(details.localPosition,
        toCanvas(pos), Offset(toX(pos.dx) + width, toY(pos.dy) + height))) {
      return this;
    }
    return super.onTapDown(details: details);
  }

  @override
  void onScaleUpdate({required ScaleUpdateDetails details}) {
    pos = Offset(toXInverse(details.localFocalPoint.dx),
        toYInverse(details.localFocalPoint.dy).clamp(yMinValue, yMaxValue));
  }
}
