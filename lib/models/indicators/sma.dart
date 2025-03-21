import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class Sma extends Indicator {
  Color lineColor = Colors.blue;
  int period = 20;
  final List<double> smaValues = [];
  final List<ICandle> candles = [];

  Sma({
    this.period = 20,
    Color? lineColor,
  }) : super(
            id: generateV4(),
            type: IndicatorType.sma,
            displayMode: DisplayMode.main) {
    if (lineColor != null) this.lineColor = lineColor;
  }

  @override
  drawIndicator({required Canvas canvas}) {
    if (candles.isEmpty || smaValues.isEmpty) return;

    print("Drawing SMA (Data length: ${candles.length})");

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Start from period-1 where actual SMA values begin
    final startIndex = period - 1;
    if (startIndex >= smaValues.length) return;

    final path = Path();
    
    // Initial point
    path.moveTo(toX(startIndex.toDouble()), toY(smaValues[startIndex]));

    // Draw the rest of the line
    for (int i = startIndex + 1; i < smaValues.length; i++) {
      path.lineTo(toX(i.toDouble()), toY(smaValues[i]));
    }

    canvas.drawPath(path, paint);
  }

  @override
  updateData(List<ICandle> data) {
    if (data.isEmpty) return;

    // If our candles list is empty, initialize it
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
    
    // Note: For DisplayMode.main, we don't need to set yMinValue and yMaxValue
    // as the indicator will use the values from the main chart
    
    // However, still set yLabelSize for consistency
    yLabelSize = getLargetRnderBoxSizeForList(
        ['0.00'], // Just a placeholder
        const TextStyle(color: Colors.black, fontSize: 12));
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
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['period'] = period;
    json['lineColor'] = colorToJson(lineColor);
    return json;
  }
}