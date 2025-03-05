import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class StochasticOscillator extends Layer {
  final List<ICandle> candles;
  final int kPeriod; // Look-back period, typically 14
  final int dPeriod; // Smoothing period, typically 3
  
  // Calculated values
  late List<double> kValues; // %K line (fast stochastic)
  late List<double> dValues; // %D line (slow stochastic)
  
  // Customizable colors
  final Color kLineColor;
  final Color dLineColor;
  
  StochasticOscillator({
    required this.candles,
    this.kPeriod = 14,
    this.dPeriod = 3,
    this.kLineColor = Colors.blue,
    this.dLineColor = Colors.red,
  }) {
    kValues = [];
    dValues = [];
    if (candles.isNotEmpty) {
      _calculateStochastic();
    }
  }
  
  void _calculateStochastic() {
    if (candles.length <= kPeriod) {
      return; // Not enough data
    }
    
    // Calculate %K values
    kValues = List.filled(candles.length, 0);
    
    for (int i = kPeriod - 1; i < candles.length; i++) {
      // Get highest high and lowest low over the look-back period
      double highestHigh = double.negativeInfinity;
      double lowestLow = double.infinity;
      
      for (int j = i - (kPeriod - 1); j <= i; j++) {
        highestHigh = math.max(highestHigh, candles[j].high);
        lowestLow = math.min(lowestLow, candles[j].low);
      }
      
      // Calculate %K: ((Current Close - Lowest Low) / (Highest High - Lowest Low)) * 100
      double range = highestHigh - lowestLow;
      
      if (range > 0) {
        kValues[i] = ((candles[i].close - lowestLow) / range) * 100;
      } else {
        // If range is zero, set to 50 (middle)
        kValues[i] = 50;
      }
    }
    
    // Calculate %D (simple moving average of %K)
    dValues = List.filled(candles.length, 0);
    
    for (int i = kPeriod + dPeriod - 2; i < candles.length; i++) {
      double sum = 0;
      for (int j = i - (dPeriod - 1); j <= i; j++) {
        sum += kValues[j];
      }
      dValues[i] = sum / dPeriod;
    }
  }

  @override
  void onUpdateData({required List<ICandle> data}) {
    if (data.isEmpty) return;
    
    // If our candles list is empty, initialize it
    if (candles.isEmpty) {
      candles.addAll(data);
    } else {
      // Find where to start adding new data
      int existingCount = candles.length;
      
      // Only add candles that come after our existing ones
      if (existingCount < data.length) {
        candles.addAll(data.sublist(existingCount));
      }
    }
    
    _calculateStochastic();
  }

  @override
  void drawLayer({required Canvas canvas}) {
    if (candles.isEmpty || kValues.isEmpty) return;
    
    // Drawing %K line
    _drawLine(canvas, kValues, kLineColor);
    
    // Drawing %D line
    _drawLine(canvas, dValues, dLineColor);
    
    // Draw overbought line (80)
    canvas.drawLine(
      Offset(leftPos, toY(80)),
      Offset(rightPos, toY(80)),
      Paint()
        ..color = Colors.red.withAlpha(128)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
    
    // Draw oversold line (20)
    canvas.drawLine(
      Offset(leftPos, toY(20)),
      Offset(rightPos, toY(20)),
      Paint()
        ..color = Colors.green.withAlpha(128)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
    
    // Draw middle line (50)
    canvas.drawLine(
      Offset(leftPos, toY(50)),
      Offset(rightPos, toY(50)),
      Paint()
        ..color = Colors.grey.withAlpha(90)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }
  
  void _drawLine(Canvas canvas, List<double> values, Color color) {
    if (values.isEmpty) return;
    
    final path = Path();
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    // Start with the first valid value
    int startIndex = kPeriod + dPeriod - 2;
    if (startIndex >= values.length) return;
    
    path.moveTo(toX(startIndex.toDouble()), toY(values[startIndex]));
    
    // Draw the rest of the line
    for (int i = startIndex + 1; i < values.length; i++) {
      path.lineTo(toX(i.toDouble()), toY(values[i]));
    }
    
    canvas.drawPath(path, paint);
  }
}