import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class Line extends Indicator {
  final List<double> values = [];
  Line()
      : super(
            id: generateV4(),
            type: IndicatorType.line,
            displayMode: DisplayMode.main);

  @override
  drawIndicator({required Canvas canvas}) {
    if (values.length < 2) return;
    for (int i = 0; i < values.length - 1; i++) {
      canvas.drawLine(
          toCanvas(Offset(i.toDouble(), values[i])),
          toCanvas(Offset((i + 1).toDouble(), values[i + 1])),
          Paint()
            ..color = Colors.purple
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  updateData(List<ICandle> data) {
    values.clear();
    values.addAll(data.map((candle) => candle.close).toList());
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['values'] = values.map((value) => value).toList();
    return json;
  }
}
