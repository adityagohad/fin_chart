import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class VerticalLine extends Layer {
  late double pos;
  late Offset startPoint;
  VerticalLine.fromTool({required this.pos})
      : super.fromTool(id: generateV4(), type: LayerType.trendLine);

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawLine(
        Offset(toX(pos) + xStepWidth / 2, topPos),
        Offset(toX(pos) + xStepWidth / 2, bottomPos),
        Paint()
          ..color = Colors.purple
          ..strokeWidth = 2);
  }

  @override
  Layer? onTapDown({required TapDownDetails details}) {
    if (isPointOnLine(details.localPosition, Offset(toX(pos), topPos),
        Offset(toX(pos), bottomPos))) {
      return this;
    }
    return super.onTapDown(details: details);
  }

  @override
  void onScaleUpdate({required ScaleUpdateDetails details}) {
    pos = toXInverse(details.localFocalPoint.dx);
  }
}
