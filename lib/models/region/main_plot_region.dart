import 'package:fin_chart/models/enums/candle_state.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

class MainPlotRegion extends PlotRegion {
  final List<ICandle> candles;
  MainPlotRegion(
      {required this.candles,
      super.type = PlotRegionType.data,
      required super.yAxisSettings,
      required super.id});

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

  @override
  void drawBaseLayer(Canvas canvas) {
    for (int i = 0; i < candles.length; i++) {
      ICandle candle = candles[i];
      Color candleColor;
      if (candle.state == CandleState.selected) {
        candleColor = Colors.orange;
      } else if (candle.state == CandleState.highlighted) {
        candleColor = Colors.purple;
      } else if (candle.open < candle.close) {
        candleColor = Colors.green;
      } else {
        candleColor = Colors.red;
      }

      Paint paint = Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.fill
        ..color = candleColor;

      canvas.drawLine(Offset(toX(i.toDouble()), toY(candle.high)),
          Offset(toX(i.toDouble()), toY(candle.low)), paint);

      canvas.drawRect(
          Rect.fromLTRB(toX(i.toDouble()) - (xStepWidth) / 4, toY(candle.open),
              toX(i.toDouble()) + (xStepWidth) / 4, toY(candle.close)),
          paint);

      // if (toX(i) >= leftPos && toX(i) <= rightPos) {
      //   canvas.drawLine(Offset(toX(i), toY(candle.high)),
      //       Offset(toX(i), toY(candle.low)), paint);

      //   canvas.drawRect(
      //       Rect.fromLTRB(toX(i) - candleWidth / 2, toY(candle.open),
      //           toX(i) + candleWidth / 2, toY(candle.close)),
      //       paint);
      // }
      // if (toX(i) > rightPos) {
      //   break;
      // }
    }
  }

  MainPlotRegion.fromJson(Map<String, dynamic> json)
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

    // Load layers if they exist
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
    json['variety'] = 'Candle';
    return json;
  }
}
