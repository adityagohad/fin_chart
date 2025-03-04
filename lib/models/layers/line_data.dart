import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class LineData extends Layer {
  final List<ICandle> candles;

  LineData({required this.candles});

  @override
  void onUpdateData({required List<ICandle> data}) {
    candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));
  }

  @override
  void drawLayer({required Canvas canvas}) {
    if (candles.length < 2) return;
    for (int i = 0; i < candles.length - 1; i++) {
      canvas.drawLine(
          toCanvas(Offset(i.toDouble(), candles[i].close)),
          toCanvas(Offset((i + 1).toDouble(), candles[i + 1].close)),
          Paint()
            ..color = Colors.purple
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);
    }
  }
}
