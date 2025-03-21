import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/ui/layer_settings/circular_area_settings_dialog.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class CircularArea extends Layer {
  late Offset point;
  double radius = 20;
  Color color = Colors.blue;
  bool isAnimating = false;

  CircularArea.fromTool({required this.point})
      : super.fromTool(id: generateV4(), type: LayerType.circularArea);

  CircularArea.fromJson({required Map<String, dynamic> data})
      : super.fromJson(
            id: data['id'],
            type: (data['type'] as String).toLayerType() ??
                LayerType.circularArea) {
    point = offsetFromJson(data['point']);
    radius = data['radius'] ?? 20.0;
    color = colorFromJson(data['color']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'type': LayerType.circularArea.name,
      'point': {'dx': point.dx, 'dy': point.dy},
      'radius': radius,
      'color': colorToJson(color)
    };
  }

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
    if (isLocked) return;
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

  @override
  void showSettingsDialog(BuildContext context, Function(Layer) onUpdate) {
    showDialog(
      context: context,
      builder: (context) => CircularAreaSettingsDialog(
        layer: this,
        onUpdate: onUpdate,
      ),
    );
  }
}
