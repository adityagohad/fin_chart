import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MACDPlotRegion extends PlotRegion {
  List<ICandle> candles;
  late List<double> macdValues;
  late List<double> signalValues;
  late List<double> histogramValues;

  final int fastPeriod; // typically 12
  final int slowPeriod; // typically 26
  final int signalPeriod; // typically 9

  MACDPlotRegion({
    required this.candles,
    this.fastPeriod = 12,
    this.slowPeriod = 26,
    this.signalPeriod = 9,
    super.type = PlotRegionType.indicator,
    required super.yAxisSettings,
  }) {
    macdValues = [];
    signalValues = [];
    histogramValues = [];
  }

  @override
  void drawBaseLayer(Canvas canvas) {
    if (candles.isEmpty || macdValues.isEmpty) return;

    final Paint macdPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Paint signalPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final Paint posHistogramPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final Paint negHistogramPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    // Draw MACD and signal lines
    _drawLine(canvas, macdValues, macdPaint);
    _drawLine(canvas, signalValues, signalPaint);

    // Draw histogram
    _drawHistogram(
        canvas, histogramValues, posHistogramPaint, negHistogramPaint);

    // Draw the zero line
    canvas.drawLine(
      Offset(leftPos, toY(0)),
      Offset(rightPos, toY(0)),
      Paint()
        ..color = Colors.grey.withAlpha(180)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawLine(Canvas canvas, List<double> values, Paint paint) {
    if (values.isEmpty) return;

    final path = Path();

    // Start from the first valid value (after sufficient periods)
    int startIndex = slowPeriod + signalPeriod - 1;
    if (startIndex >= values.length || startIndex >= candles.length) return;

    path.moveTo(toX(startIndex.toDouble()), toY(values[startIndex]));

    // Only draw up to the number of candles we actually have
    int endIndex = math.min(values.length, candles.length);

    for (int i = startIndex + 1; i < endIndex; i++) {
      path.lineTo(toX(i.toDouble()), toY(values[i]));
    }

    canvas.drawPath(path, paint);
  }

  void _drawHistogram(
      Canvas canvas, List<double> values, Paint posPaint, Paint negPaint) {
    if (values.isEmpty) return;

    final histWidth = xStepWidth * 0.4;

    // Start from the first valid value (after sufficient periods)
    int startIndex = slowPeriod + signalPeriod - 1;
    if (startIndex >= values.length || startIndex >= candles.length) return;

    // Only draw up to the number of candles we actually have
    int endIndex = math.min(values.length, candles.length);

    for (int i = startIndex; i < endIndex; i++) {
      final x = toX(i.toDouble());
      final zero = toY(0);
      final y = toY(values[i]);

      canvas.drawRect(
          Rect.fromPoints(
              Offset(x - histWidth, zero), Offset(x + histWidth, y)),
          values[i] > 0 ? posPaint : negPaint);
    }
  }

  @override
  void updateData(List<ICandle> data) {
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

    _calculateIndicators();

    // Determine min and max values for y-axis
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;

    for (int i = 0; i < macdValues.length; i++) {
      if (i >= slowPeriod + signalPeriod - 1) {
        minValue = math.min(minValue, macdValues[i]);
        minValue = math.min(minValue, signalValues[i]);
        minValue = math.min(minValue, histogramValues[i]);

        maxValue = math.max(maxValue, macdValues[i]);
        maxValue = math.max(maxValue, signalValues[i]);
        maxValue = math.max(maxValue, histogramValues[i]);
      }
    }

    // Add a bit of padding
    double range = maxValue - minValue;
    minValue -= range * 0.1;
    maxValue += range * 0.1;

    // Ensure zero is included in the range
    if (minValue > 0) minValue = 0;
    if (maxValue < 0) maxValue = 0;

    yMinValue = minValue;
    yMaxValue = maxValue;

    yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;

    yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);
  }

  void _calculateIndicators() {
    if (candles.isEmpty) {
      macdValues = [];
      signalValues = [];
      histogramValues = [];
      return;
    }

    // Calculate EMAs
    List<double> prices = candles.map((c) => c.close).toList();
    List<double> fastEMA = _calculateEMA(prices, fastPeriod);
    List<double> slowEMA = _calculateEMA(prices, slowPeriod);

    // Calculate MACD values
    macdValues = List.filled(prices.length, 0);
    for (int i = slowPeriod - 1; i < prices.length; i++) {
      macdValues[i] = fastEMA[i] - slowEMA[i];
    }

    // Calculate signal line (EMA of MACD)
    signalValues = _calculateEMA(macdValues, signalPeriod);

    // Calculate histogram
    histogramValues = List.filled(prices.length, 0);
    // Only calculate histogram where we have valid signal values
    int validStartIndex = slowPeriod + signalPeriod - 2;
    for (int i = validStartIndex; i < macdValues.length; i++) {
      histogramValues[i] = macdValues[i] - signalValues[i];
    }
  }

  List<double> _calculateEMA(List<double> prices, int period) {
    List<double> ema = List.filled(prices.length, 0);

    // Initialize SMA for first EMA value
    if (prices.length >= period) {
      double sum = 0;
      for (int i = 0; i < period; i++) {
        sum += prices[i];
      }
      ema[period - 1] = sum / period;

      // Calculate multiplier: (2 / (period + 1))
      double multiplier = 2 / (period + 1);

      // Calculate EMA values
      for (int i = period; i < prices.length; i++) {
        ema[i] = (prices[i] - ema[i - 1]) * multiplier + ema[i - 1];
      }
    }

    return ema;
  }
}
