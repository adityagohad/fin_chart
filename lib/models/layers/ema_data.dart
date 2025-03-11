import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class EmaData extends Layer {
  List<ICandle> candles;
  final int period;
  final Color lineColor;
  final List<double> emaValues = [];

  EmaData({
    required this.candles,
    this.period = 20,
    this.lineColor = Colors.orange,
  }) {
    // Calculate EMA immediately in constructor
    _calculateEMA();
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
    
    _calculateEMA();
  }

  void _calculateEMA() {
    emaValues.clear();
    
    if (candles.length < period) {
      return;
    }
    
    // Calculate smoothing factor: 2 / (period + 1)
    double smoothing = 2.0 / (period + 1);
    
    // Get SMA for the first EMA value
    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += candles[i].close;
    }
    double firstEma = sum / period;
    
    // Add placeholder zeros for candles before the period
    for (int i = 0; i < period - 1; i++) {
      emaValues.add(0);
    }
    
    // Add the first EMA value (which is just the SMA)
    emaValues.add(firstEma);
    
    // Calculate the rest of the EMA values
    for (int i = period; i < candles.length; i++) {
      double currentPrice = candles[i].close;
      double previousEma = emaValues.last;
      
      // EMA formula: EMA = (Close - Previous EMA) * smoothing + Previous EMA
      double currentEma = (currentPrice - previousEma) * smoothing + previousEma;
      emaValues.add(currentEma);
    }
  }

  @override
  void drawLayer({required Canvas canvas}) {
    if (candles.isEmpty || emaValues.isEmpty) {
      return;
    }
    
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    
    // Start from period-1 where actual EMA values begin
    final startIndex = period - 1;
    if (startIndex >= emaValues.length) {
      return;
    }
    
    final path = Path();
    bool pathStarted = false;
    
    // Draw only the valid EMA values
    for (int i = startIndex; i < emaValues.length; i++) {
      if (emaValues[i] == 0) continue; // Skip placeholder values
      
      final x = toX(i.toDouble());
      final y = toY(emaValues[i]);
      
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