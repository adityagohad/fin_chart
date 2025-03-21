import 'dart:math' as math;
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class BollingerBands extends Indicator {
  int period;
  double multiplier;
  Color upperBandColor;
  Color middleBandColor;
  Color lowerBandColor;
  double opacity;

  final List<double> smaValues = [];
  final List<double> upperBandValues = [];
  final List<double> lowerBandValues = [];
  final List<ICandle> candles = [];

  BollingerBands({
    this.period = 20,
    this.multiplier = 2.0,
    this.upperBandColor = Colors.red,
    this.middleBandColor = Colors.blue,
    this.lowerBandColor = Colors.green,
    this.opacity = 0.2,
  }) : super(
            id: generateV4(),
            type: IndicatorType.bollingerBand,
            displayMode: DisplayMode.main);

  @override
  drawIndicator({required Canvas canvas}) {
    if (candles.isEmpty || smaValues.isEmpty) return;

    print("Drawing Bollinger Bands (Data length: ${candles.length})");

    // Draw filled area between bands for visualization first (so it's behind the lines)
    _drawFilledArea(canvas, upperBandValues, lowerBandValues);

    // Draw the middle band (SMA)
    _drawLine(canvas, smaValues, middleBandColor);

    // Draw upper band
    _drawLine(canvas, upperBandValues, upperBandColor);

    // Draw lower band
    _drawLine(canvas, lowerBandValues, lowerBandColor);
  }

  void _drawLine(Canvas canvas, List<double> values, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool pathStarted = false;

    for (int i = period - 1; i < values.length; i++) {
      if (values[i] == 0) continue;

      final x = toX(i.toDouble());
      final y = toY(values[i]);

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

  void _drawFilledArea(Canvas canvas, List<double> upper, List<double> lower) {
    final fillPaint = Paint()
      ..color = middleBandColor.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    bool pathStarted = false;

    // First draw the upper band
    for (int i = period - 1; i < upper.length; i++) {
      if (upper[i] == 0) continue;

      final x = toX(i.toDouble());
      final y = toY(upper[i]);

      if (!pathStarted) {
        path.moveTo(x, y);
        pathStarted = true;
      } else {
        path.lineTo(x, y);
      }
    }

    // Then draw the lower band in reverse
    for (int i = lower.length - 1; i >= period - 1; i--) {
      if (lower[i] == 0) continue;

      final x = toX(i.toDouble());
      final y = toY(lower[i]);

      path.lineTo(x, y);
    }

    if (pathStarted) {
      path.close();
      canvas.drawPath(path, fillPaint);
    }
  }

  @override
  updateData(List<ICandle> data) {
    if (data.isEmpty) return;

    // Clear the existing candles list before adding new data
    candles.clear();
    candles.addAll(data);

    _calculateBollingerBands();

    // For DisplayMode.main, we don't need to set yMinValue and yMaxValue
    // as the indicator will use the values from the main chart

    // However, still set yLabelSize for consistency
    yLabelSize = getLargetRnderBoxSizeForList(
        ['0.00'], // Just a placeholder
        const TextStyle(color: Colors.black, fontSize: 12));
  }

  void _calculateBollingerBands() {
    print("Calculating Bollinger Bands for ${candles.length} candles");
    if (candles.length < period) {
      smaValues.clear();
      upperBandValues.clear();
      lowerBandValues.clear();
      return;
    }

    // Calculate the starting index for new candles
    int startIndex = smaValues.length;

    // If no previous calculations exist, initialize the lists
    if (startIndex == 0) {
      smaValues.addAll(List.filled(period - 1, 0.0));
      upperBandValues.addAll(List.filled(period - 1, 0.0));
      lowerBandValues.addAll(List.filled(period - 1, 0.0));
      startIndex = period - 1;
    }

    // Calculate SMA and standard deviation for new candles
    for (int i = startIndex; i < candles.length; i++) {
      // Calculate SMA for this window
      double sum = 0;
      for (int j = i - (period - 1); j <= i; j++) {
        sum += candles[j].close;
      }
      double sma = sum / period;
      smaValues.add(sma);

      // Calculate standard deviation
      double variance = 0;
      for (int j = i - (period - 1); j <= i; j++) {
        variance += math.pow(candles[j].close - sma, 2);
      }
      double stdDev = math.sqrt(variance / period);

      // Calculate upper and lower bands
      upperBandValues.add(sma + (multiplier * stdDev));
      lowerBandValues.add(sma - (multiplier * stdDev));
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['period'] = period;
    json['multiplier'] = multiplier;
    json['upperBandColor'] = colorToJson(upperBandColor);
    json['middleBandColor'] = colorToJson(middleBandColor);
    json['lowerBandColor'] = colorToJson(lowerBandColor);
    json['opacity'] = opacity;
    return json;
  }
}