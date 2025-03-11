import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class RsiPlotRegion extends PlotRegion {
  List<ICandle> candles;
  Color lineColor = Colors.blue;
  int period = 14;
  final List<double> rsiValues = [];
  RsiPlotRegion(
      {required this.candles,
      super.type = PlotRegionType.indicator,
      required super.yAxisSettings});

  @override
  void drawBaseLayer(Canvas canvas) {
    if (rsiValues.isEmpty || candles.isEmpty) return;

    final path = Path();

    // Start drawing from the first calculated RSI value (after period)
    int startIndex = candles.length - rsiValues.length;

    // Set starting point
    path.moveTo(
      toX(startIndex.toDouble()),
      toY(rsiValues[0]),
    );

    // Draw the line
    for (int i = 1; i < rsiValues.length; i++) {
      path.lineTo(
        toX((startIndex + i).toDouble()),
        toY(rsiValues[i]),
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

    // Draw the overbought line (70)
    canvas.drawLine(
      Offset(leftPos, toY(70)),
      Offset(rightPos, toY(70)),
      Paint()
        ..color = Colors.red.withAlpha((0.5 * 255).toInt())
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // Draw the oversold line (30)
    canvas.drawLine(
      Offset(leftPos, toY(30)),
      Offset(rightPos, toY(30)),
      Paint()
        ..color = Colors.green.withAlpha((0.5 * 255).toInt())
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  void updateData(List<ICandle> data) {
    candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));

    rsiValues.clear();

    if (candles.length <= period) {
      return;
    }

    List<double> gains = [];
    List<double> losses = [];

    // Calculate initial gains and losses
    for (int i = 1; i <= period; i++) {
      double change = candles[i].close - candles[i - 1].close;
      gains.add(change > 0 ? change : 0);
      losses.add(change < 0 ? -change : 0);
    }

    // Calculate first RSI value
    double avgGain = gains.reduce((a, b) => a + b) / period;
    double avgLoss = losses.reduce((a, b) => a + b) / period;

    // Add first RSI value
    if (avgLoss == 0) {
      rsiValues.add(100);
    } else {
      double rs = avgGain / avgLoss;
      rsiValues.add(100 - (100 / (1 + rs)));
    }

    // Calculate remaining RSI values
    for (int i = period + 1; i < candles.length; i++) {
      double change = candles[i].close - candles[i - 1].close;
      double currentGain = change > 0 ? change : 0;
      double currentLoss = change < 0 ? -change : 0;

      // Smooth averages
      avgGain = ((avgGain * (period - 1)) + currentGain) / period;
      avgLoss = ((avgLoss * (period - 1)) + currentLoss) / period;

      if (avgLoss == 0) {
        rsiValues.add(100);
      } else {
        double rs = avgGain / avgLoss;
        rsiValues.add(100 - (100 / (1 + rs)));
      }
    }

    yMaxValue = 100;
    yMinValue = 0;

    yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;

    yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);
  }
}
