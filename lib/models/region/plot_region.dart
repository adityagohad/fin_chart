import 'package:fin_chart/models/enums/plot_region_type.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/region/main_plot_region.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/models/layers/arrow.dart';
import 'package:fin_chart/models/layers/circular_area.dart';
import 'package:fin_chart/models/layers/horizontal_band.dart';
import 'package:fin_chart/models/layers/horizontal_line.dart';
import 'package:fin_chart/models/layers/label.dart';
import 'package:fin_chart/models/layers/rect_area.dart';
import 'package:fin_chart/models/layers/trend_line.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:flutter/material.dart';

abstract class PlotRegion with RegionProp {
  final String id;
  final PlotRegionType type;
  final YAxisSettings yAxisSettings;
  final List<Layer> layers;
  late Size yLabelSize;
  late List<double> yValues;
  bool isSelected = false;

  PlotRegion(
      {required this.id,
      required this.type,
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

  Offset getRealCoordinates(Offset selectedPoint) {
    return toReal(selectedPoint);
  }

  void addLayer(Layer layer) {
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

  void drawYAxis(Canvas canvas);

  void drawLayers(Canvas canvas) {
    for (final layer in layers) {
      layer.drawLayer(canvas: canvas);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'yAxisSettings': {
        'yAxisPos': yAxisSettings.yAxisPos.name,
        'axisColor': colorToJson(yAxisSettings.axisColor),
        'strokeWidth': yAxisSettings.strokeWidth,
        'textStyle': {
          'color':
              colorToJson(yAxisSettings.axisTextStyle.color ?? Colors.black),
          'fontSize': yAxisSettings.axisTextStyle.fontSize,
          'fontWeight':
              yAxisSettings.axisTextStyle.fontWeight == FontWeight.bold
                  ? 'bold'
                  : 'normal',
        },
      },
      'yMinValue': yMinValue,
      'yMaxValue': yMaxValue,
      //'layers': layers.map((layer) => layer.toJson()).toList(),
    };
  }

  static Layer? layerFromJson(Map<String, dynamic> json) {
    String? layerType = json['type'];
    if (layerType == null) return null;

    switch (layerType) {
      case 'trendLine':
        return TrendLine.fromJson(data: json);
      case 'horizontalLine':
        return HorizontalLine.fromJson(data: json);
      case 'horizontalBand':
        return HorizontalBand.fromJson(data: json);
      case 'label':
        return Label.fromJson(data: json);
      case 'circularArea':
        return CircularArea.fromJson(data: json);
      case 'rectArea':
        return RectArea.fromJson(data: json);
      case 'arrow':
        return Arrow.fromJson(data: json);
      default:
        return null;
    }
  }

  /// Create region from JSON representation
  static PlotRegion fromJson(Map<String, dynamic> json) {
    switch (json['variety']) {
      case 'Candle':
        return MainPlotRegion.fromJson(json);
    }
    throw UnimplementedError(
        'PlotRegion.fromJson must be implemented by subclasses');
  }

  void drawBaseLayer(Canvas canvas);

  void updateData(List<ICandle> data);
}
