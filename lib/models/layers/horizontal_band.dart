import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/ui/layer_settings/horizontal_band_settings_dialog.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class HorizontalBand extends Layer {
  late double value;
  late double allowedError;
  Color color = Colors.amber;

  HorizontalBand.fromTool({required this.value, this.allowedError = 40})
      : super.fromTool();

  HorizontalBand.fromJson({required Map<String, dynamic> data}) : super.fromJson() {
    value = data['value'];
    allowedError = data['allowedError'] ?? 40.0;
    color = colorFromJson(data['color']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'horizontalBand',
      'value': value,
      'allowedError': allowedError,
      'color': colorToJson(color)
    };
  }

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawRect(
        Rect.fromLTWH(leftPos, toY(value) - allowedError / 2,
            rightPos - leftPos, allowedError),
        Paint()
          ..color = color.withAlpha(100)
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

  @override
  void showSettingsDialog(BuildContext context, Function(Layer) onUpdate) {
    showDialog(
      context: context,
      builder: (context) => HorizontalBandSettingsDialog(
        layer: this,
        onUpdate: onUpdate,
      ),
    );
  }
}
