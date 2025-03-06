import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class SimpleMovingAverage extends Layer {
  final List<ICandle> candles;
  final int period;
  final Color lineColor;
  final List<double> smaValues = [];

  SimpleMovingAverage({
    required this.candles, 
    this.period = 20,
    this.lineColor = Colors.blue,
  }) {
    _calculateSMA();
  }

  void _calculateSMA() {
    smaValues.clear();
    
    if (candles.length < period) {
      return;
    }
    
    // Calculate each SMA value
    for (int i = period - 1; i < candles.length; i++) {
      double sum = 0;
      for (int j = i - (period - 1); j <= i; j++) {
        sum += candles[j].close;
      }
      smaValues.add(sum / period);
    }
  }

  @override
  void onUpdateData({required List<ICandle> data}) {
    if (data.isNotEmpty) {
      candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));
      _calculateSMA();
    }
  }

  @override
  void drawLayer({required Canvas canvas}) {
    if (smaValues.isEmpty || candles.isEmpty) return;
    
    final path = Path();
    
    // Start drawing from the first calculated SMA value (after period)
    int startIndex = period - 1;
    
    // Set starting point
    path.moveTo(
      toX(startIndex.toDouble()),
      toY(smaValues[0]),
    );
    
    // Draw the line
    for (int i = 1; i < smaValues.length; i++) {
      path.lineTo(
        toX((startIndex + i).toDouble()),
        toY(smaValues[i]),
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