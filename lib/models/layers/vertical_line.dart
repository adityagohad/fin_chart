import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class VerticalLine extends Layer {
  late double pos;
  late Offset startPoint;

  VerticalLine.fromTool({required this.pos})
      : super.fromTool(id: generateV4(), type: LayerType.trendLine);

  VerticalLine.fromJson({required Map<String, dynamic> data})
      : super.fromJson(
            id: data['id'],
            type: (data['type'] as String).toLayerType() ??
                LayerType.verticalLine) {
    pos = data['pos'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'type': LayerType.verticalLine.name, 'pos': pos};
  }

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
    if (isLocked) return;
    pos = toXInverse(details.localFocalPoint.dx);
  }

  @override
  Widget layerToolTip(
      {Widget? child,
      required Function()? onSettings,
      required Function()? onLockUpdate,
      required Function()? onDelete}) {
    return Container();
  }
}
