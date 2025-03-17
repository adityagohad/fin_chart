import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class DummyPlotRegion extends PlotRegion {
  final List<ICandle> candles;
  DummyPlotRegion(
      {required this.candles,
      super.type = PlotRegionType.indicator,
      required super.yAxisSettings,
      required super.id});

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

  DummyPlotRegion.fromJson(Map<String, dynamic> json)
      : candles = [],
        super(
          id: json['id'],
          type: PlotRegionType.values.firstWhere((t) => t.name == json['type'],
              orElse: () => PlotRegionType.data),
          yAxisSettings: YAxisSettings(
            yAxisPos: YAxisPos.values.firstWhere(
                (pos) => pos.name == json['yAxisSettings']['yAxisPos'],
                orElse: () => YAxisPos.right),
            axisColor: colorFromJson(json['yAxisSettings']['axisColor']),
            strokeWidth: json['yAxisSettings']['strokeWidth'] ?? 1.0,
            axisTextStyle: TextStyle(
              color: colorFromJson(json['yAxisSettings']['textStyle']['color']),
              fontSize: json['yAxisSettings']['textStyle']['fontSize'] ?? 12.0,
              fontWeight:
                  json['yAxisSettings']['textStyle']['fontWeight'] == 'bold'
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),
        ) {
    yMinValue = json['yMinValue'];
    yMaxValue = json['yMaxValue'];

    // Load layers
    if (json['layers'] != null) {
      for (var layerJson in json['layers']) {
        Layer? layer = PlotRegion.layerFromJson(layerJson);
        if (layer != null) {
          layers.add(layer);
        }
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['variety'] = 'Line';
    return json;
  }
}
