import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class SmaData extends Layer {
  List<ICandle> candles;
  final int period;
  final Color lineColor;
  final List<double> smaValues = [];
  bool debug = true;

  SmaData({
    required this.candles,
    this.period = 20,
    this.lineColor = Colors.blue,
  }) : super.fromTool(id: generateV4()) {
    // Calculate SMA immediately in constructor
    _calculateSMA();
  }

  @override
  void onUpdateData({required List<ICandle> data}) {
    // Add only new candles
    if (candles.isEmpty) {
      candles.addAll(data);
    } else {
      // Only add new candles
      int existingCount = candles.length;
      if (data.length > existingCount) {
        candles.addAll(data.sublist(existingCount));
      }
    }

    _calculateSMA();
  }

  void _calculateSMA() {
    smaValues.clear();

    if (candles.length < period) {
      return;
    }

    // Calculate SMA values
    for (int i = 0; i < candles.length; i++) {
      if (i < period - 1) {
        smaValues.add(0); // Placeholder for earlier values
      } else {
        double sum = 0;
        for (int j = i - (period - 1); j <= i; j++) {
          sum += candles[j].close;
        }
        smaValues.add(sum / period);
      }
    }
  }

  @override
  void drawLayer({required Canvas canvas}) {
    if (candles.isEmpty || smaValues.isEmpty) {
      return;
    }

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Start from period-1 where actual SMA values begin
    final startIndex = period - 1;
    if (startIndex >= smaValues.length) {
      return;
    }

    final path = Path();
    bool pathStarted = false;

    // Draw only the valid SMA values
    for (int i = startIndex; i < smaValues.length; i++) {
      final x = toX(i.toDouble());
      final y = toY(smaValues[i]);

      if (!pathStarted) {
        path.moveTo(x, y);
        pathStarted = true;
      } else {
        path.lineTo(x, y);
      }
    }

    if (pathStarted) {
      canvas.drawPath(path, paint);
    }
  }
}
