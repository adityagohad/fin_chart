import 'dart:ui';

import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/utils/calculations.dart';

class AdxRegion extends PlotRegion {
  final List<ICandle> candles;
  AdxRegion(
      {required this.candles,
      super.type = PlotRegionType.indicator,
      required super.yAxisSettings,
      required super.id});

  @override
  void drawBaseLayer(Canvas canvas) {
    // TODO: implement drawBaseLayer
  }

  @override
  void updateData(List<ICandle> data) {
    candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));
    (double, double) range = findMinMaxWithPercentage(candles);
    yMinValue = range.$1;
    yMaxValue = range.$2;

    yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;

    yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);
  }
}
