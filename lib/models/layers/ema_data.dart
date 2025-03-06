import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class EMAData extends Layer {
  final List<ICandle> candles;
  final int period;
  final Color lineColor;
  final List<double> emaValues = [];

  EMAData({
    required this.candles, 
    this.period = 20,
    this.lineColor = Colors.orange,
  }) {
    _calculateEMA();
  }

  void _calculateEMA() {
    emaValues.clear();
    
    if (candles.length <= period) {
      return;
    }
    
    // Calculate initial SMA for first EMA value
    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += candles[i].close;
    }
    double sma = sum / period;
    emaValues.add(sma);
    
    // Calculate multiplier: (2 / (period + 1))
    double multiplier = 2 / (period + 1);
    
    // Calculate EMA values
    for (int i = period; i < candles.length; i++) {
      double ema = (candles[i].close - emaValues.last) * multiplier + emaValues.last;
      emaValues.add(ema);
    }
  }

  @override
  void onUpdateData({required List<ICandle> data}) {
    if (data.isNotEmpty) {
      candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));
      _calculateEMA();
    }
  }

  @override
  void drawLayer({required Canvas canvas}) {
    if (emaValues.isEmpty || candles.isEmpty) return;
    
    final path = Path();
    
    // Start drawing from the first calculated EMA value (after period)
    int startIndex = period - 1;
    
    // Set starting point
    path.moveTo(
      toX(startIndex.toDouble()),
      toY(emaValues[0]),
    );
    
    // Draw the line
    for (int i = 1; i < emaValues.length; i++) {
      path.lineTo(
        toX((startIndex + i).toDouble()),
        toY(emaValues[i]),
      );
    }
    
    // Draw the path
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
}