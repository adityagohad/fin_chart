import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

enum PlotRegionType { data, indicator }

class PlotRegion with RegionProp {
  final PlotRegionType type;
  final YAxisSettings yAxisSettings;
  final List<Layer> layers;

  PlotRegion({
    required this.type,
    required this.yAxisSettings,
    List<Layer>? layers,
    double yMinValue = 0,
    double yMaxValue = 1,
  }) : layers = layers ?? [] {
    this.yMinValue = yMinValue;
    this.yMaxValue = yMaxValue;
  }

  PlotRegion? isRegionReadyForResize(Offset selectedPoint) {
    // print("left Point : ${Offset(leftPos, bottomPos)}");
    // print("right Point : ${Offset(rightPos, bottomPos)}");
    // print("seletedPoint : $selectedPoint");
    if (isPointOnLine(selectedPoint, Offset(leftPos, bottomPos),
            Offset(rightPos, bottomPos)) ||
        isPointOnLine(
            selectedPoint, Offset(leftPos, topPos), Offset(rightPos, topPos))) {
      return this;
    } else {
      return null;
    }
  }

  void drawYAxis(Canvas canvas) {
    List<double> yValues = generateNiceAxisValues(yMinValue, yMaxValue);
    double valuseDiff = yValues.last - yValues.first;
    double posDiff = bottomPos - topPos;

    for (double value in yValues) {
      double pos = bottomPos - (value - yValues.first) * posDiff / valuseDiff;

      if (!(value == yValues.first || value == yValues.last)) {
        canvas.drawLine(Offset(leftPos, pos), (Offset(rightPos, pos)), Paint());
        final TextPainter text = TextPainter(
          text: TextSpan(
            text: value.toStringAsFixed(2),
            style: yAxisSettings.axisTextStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (yAxisSettings.yAxisPos == YAxisPos.left) {
          text.paint(
              canvas,
              Offset(leftPos - (text.width + yLabelPadding / 2),
                  pos - text.height / 2));
        }
        if (yAxisSettings.yAxisPos == YAxisPos.right) {
          text.paint(canvas,
              Offset(rightPos + yLabelPadding / 2, pos - text.height / 2));
        }
      }
    }

    if (yAxisSettings.yAxisPos == YAxisPos.left) {
      canvas.drawLine(
          Offset(leftPos, topPos),
          Offset(leftPos, bottomPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
    if (yAxisSettings.yAxisPos == YAxisPos.right) {
      canvas.drawLine(
          Offset(rightPos, topPos),
          Offset(rightPos, bottomPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
  }

  void drawAxisValue(Canvas canvas) {
    for (final layer in layers) {
      layer.updateRegionProp(
          leftPos: leftPos,
          topPos: topPos,
          rightPos: rightPos,
          bottomPos: bottomPos,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: yMinValue,
          yMaxValue: yMaxValue);
      if (yAxisSettings.yAxisPos == YAxisPos.left) {
        layer.drawLeftAxisValues(canvas: canvas);
      } else if (yAxisSettings.yAxisPos == YAxisPos.right) {
        layer.drawRightAxisValues(canvas: canvas);
      }
    }
  }

  void drawLayers(Canvas canvas) {
    for (final layer in layers) {
      layer.drawLayer(canvas: canvas);
    }
  }

  void updateData(List<ICandle> data) {
    if (type == PlotRegionType.data) {
      List<ICandle> calulateData = data
          .map((c) => ICandle(
              id: c.id,
              date: c.date,
              open: c.open,
              high: c.high,
              low: c.low,
              close: c.close,
              volume: c.volume))
          .toList();
      (double, double) range = findMinMaxWithPercentage(calulateData);
      yMinValue = range.$1;
      yMaxValue = range.$2;

      List<double> yValues = generateNiceAxisValues(yMinValue, yMaxValue);

      yMinValue = yValues.first;
      yMaxValue = yValues.last;

      for (final layer in layers) {
        if (type == PlotRegionType.data) {
          layer.onUpdateData(data: data);
        } else {
          layer.onUpdateData(data: calulateData);
        }
      }
    }
    if (type == PlotRegionType.indicator) {
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
      (double, double) range = findMinMaxWithPercentage(calulateData);
      yMinValue = range.$1;
      yMaxValue = range.$2;

      List<double> yValues = generateNiceAxisValues(yMinValue, yMaxValue);

      yMinValue = yValues.first;
      yMaxValue = yValues.last;

      for (final layer in layers) {
        if (type == PlotRegionType.data) {
          layer.onUpdateData(data: data);
        } else {
          layer.onUpdateData(data: calulateData);
        }
      }
    }
  }
}
