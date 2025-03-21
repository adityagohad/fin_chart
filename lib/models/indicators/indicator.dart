import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:flutter/material.dart';

enum IndicatorType { rsi, macd, sma, ema, bollingerBand, stochastic, line }

enum DisplayMode { main, panel }

abstract class Indicator with RegionProp {
  final String id;
  final IndicatorType type;
  final DisplayMode displayMode;
  late List<double> yValues;
  late Size yLabelSize;

  Indicator({required this.id, required this.type, required this.displayMode});

  updateData(List<ICandle> data);

  drawIndicator({required Canvas canvas});

  Widget buidlIndictorChartWidget() {
    throw UnimplementedError();
  }

  showIndicatorSettings(BuildContext context, Indicator indicator) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'displayMode': displayMode.name,
    };
  }

  factory Indicator.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
