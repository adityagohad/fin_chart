import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

enum PlotRegionType { main, indicator }

class PlotRegion with RegionProp {
  final PlotRegionType type;
  final YAxisSettings yAxisSettings;
  final List<Layer> layers;

  PlotRegion(
      {required this.type, required this.yAxisSettings, List<Layer>? layers})
      : layers = layers ?? [];

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
      // layer.updateRegionProp(
      //     leftPos: leftPos,
      //     topPos: topPos,
      //     rightPos: rightPos,
      //     bottomPos: bottomPos,
      //     xStepWidth: xStepWidth,
      //     xOffset: xOffset,
      //     yMinValue: yMinValue,
      //     yMaxValue: yMaxValue);
      layer.drawLayer(canvas: canvas);
    }
  }
}
