import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/ui/layer_settings/horizontal_line_settings_dialog.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends Layer {
  late double value;
  Color color = Colors.blue;
  double strokeWidth = 2;

  HorizontalLine.fromTool({required this.value})
      : super.fromTool(id: generateV4(), type: LayerType.horizontalLine);

  HorizontalLine.fromJson({required Map<String, dynamic> data})
      : super.fromJson(
            id: data['id'],
            type: (data['type'] as String).toLayerType() ??
                LayerType.horizontalLine) {
    value = data['value'];
    color = colorFromJson(data['color']);
    strokeWidth = data['strokeWidth'] ?? 2.0;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'type': LayerType.horizontalLine.name,
      'value': value,
      'color': colorToJson(color),
      'strokeWidth': strokeWidth
    };
  }

  @override
  void drawLayer({required Canvas canvas}) {
    canvas.drawLine(
        Offset(leftPos, toY(value)),
        Offset(rightPos, toY(value)),
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth);
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
        Paint()..color = color);

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

  @override
  void showSettingsDialog(BuildContext context, Function(Layer) onUpdate) {
    showDialog(
      context: context,
      builder: (context) => HorizontalLineSettingsDialog(
        layer: this,
        onUpdate: onUpdate,
      ),
    );
  }
}
