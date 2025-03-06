import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class DummyPlotRegion extends PlotRegion {
  final List<ICandle> candles;
  DummyPlotRegion(
      {required this.candles,
      super.type = PlotRegionType.indicator,
      required super.yAxisSettings});

  @override
  void updateData(List<ICandle> data) {
    List<ICandle> calulateData = data
        .map((c) => ICandle(
            id: c.id,
            date: c.date,
            open: c.open / 100,
            high: c.high / 100,
            low: c.low / 100,
            close: c.close / 100,
            volume: c.volume))
        .toList();
    candles.addAll(calulateData.sublist(candles.isEmpty ? 0 : candles.length));
    (double, double) range = findMinMaxWithPercentage(candles);
    yMinValue = range.$1;
    yMaxValue = range.$2;

    yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;
  }

  @override
  void drawBaseLayer(Canvas canvas) {
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
