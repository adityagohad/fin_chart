import 'package:fin_chart/models/enums/layer_type.dart';
import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

abstract class PlotRegion with RegionProp {
  final PlotRegionType type;
  final YAxisSettings yAxisSettings;
  final List<Layer> layers;
  late Size yLabelSize;
  late List<double> yValues;
  bool isSelected = false;

  PlotRegion(
      {required this.type,
      required this.yAxisSettings,
      List<Layer>? layers,
      double yMinValue = 0,
      double yMaxValue = 1})
      : layers = layers ?? [] {
    this.yMinValue = yMinValue;
    this.yMaxValue = yMaxValue;
    yValues = generateNiceAxisValues(yMinValue, yMaxValue);
    this.yMinValue = yValues.first;
    this.yMaxValue = yValues.last;
    yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);
  }

  PlotRegion? isRegionReadyForResize(Offset selectedPoint) {
    if (isPointOnLine(selectedPoint, Offset(leftPos, bottomPos),
            Offset(rightPos, bottomPos)) ||
        isPointOnLine(
            selectedPoint, Offset(leftPos, topPos), Offset(rightPos, topPos))) {
      return this;
    } else {
      return null;
    }
  }

  PlotRegion? regionSelect(Offset selectedPoint) {
    if (isPointNearRectFromDiagonalVertices(
        selectedPoint, Offset(leftPos, topPos), Offset(rightPos, bottomPos))) {
      isSelected = true;
      return this;
    } else {
      isSelected = false;
      return null;
    }
  }

  void addLayer(LayerType layerToAdd, List<Offset> drawPoints) {
    Layer layer;
    switch (layerToAdd) {
      case LayerType.chartPointer:
        // TODO: Handle this case.
        throw UnimplementedError();
      case LayerType.text:
        // TODO: Handle this case.
        throw UnimplementedError();
      case LayerType.trendLine:
        layer = TrendLine.fromTool(
            from: toReal(drawPoints.first),
            to: toReal(drawPoints.last),
            startPoint: drawPoints.first);
        break;
      case LayerType.horizontalLine:
        layer = HorizontalLine.fromTool(value: toYInverse(drawPoints.first.dy));
        break;
      case LayerType.horizontalBand:
        // TODO: Handle this case.
        throw UnimplementedError();
      case LayerType.rectArea:
        // TODO: Handle this case.
        throw UnimplementedError();
      case LayerType.circularArea:
        layer = CircularArea.fromTool(point: toReal(drawPoints.first));
        break;
    }
    layers.add(layer);
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

  void drawYAxis(Canvas canvas) {
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

  void drawLayers(Canvas canvas) {
    for (final layer in layers) {
      layer.drawLayer(canvas: canvas);
    }
  }

  void drawBaseLayer(Canvas canvas);

  void updateData(List<ICandle> data);
}
