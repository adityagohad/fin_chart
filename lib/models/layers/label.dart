import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/ui/layer_settings/label_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fin_chart/utils/calculations.dart';

class Label extends Layer {
  late Offset pos;
  late String label;
  late TextStyle textStyle;
  late double width;
  late double height;

  Label.fromTool(
      {required this.pos, required this.label, required this.textStyle})
      : super.fromTool(id: generateV4(), type: LayerType.label);

  Label.fromJson({required Map<String, dynamic> data})
      : super.fromJson(
            id: data['id'],
            type: (data['type'] as String).toLayerType() ?? LayerType.label) {
    pos = offsetFromJson(data['pos']);
    label = data['label'] ?? '';
    textStyle = TextStyle(
      color: colorFromJson(data['textColor']),
      fontSize: data['fontSize'] ?? 16.0,
      fontWeight:
          data['fontWeight'] == 'bold' ? FontWeight.bold : FontWeight.normal,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'type': LayerType.label.name,
      'pos': {'dx': pos.dx, 'dy': pos.dy},
      'label': label,
      'textColor': colorToJson(textStyle.color ?? Colors.black),
      'fontSize': textStyle.fontSize,
      'fontWeight': textStyle.fontWeight == FontWeight.bold ? 'bold' : 'normal',
    };
  }

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

  @override
  void showSettingsDialog(BuildContext context, Function(Layer) onUpdate) {
    showDialog(
      context: context,
      builder: (context) => LabelSettingsDialog(
        layer: this,
        onUpdate: onUpdate,
      ),
    );
  }
}
