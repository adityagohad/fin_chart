import 'package:fin_chart/models/layers/layer.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:flutter/material.dart';

enum PlotRegionType { main, indicator }

class PlotRegion with RegionProp {
  final PlotRegionType type;
  // late double leftPos;
  // late double xStepWidth;
  // late double xOffset;
  // late double topPos;
  // late double bottomPos;
  // late double yMinValue;
  // late double yMaxValue;
  final YAxisSettings yAxisSettings;
  final List<Layer> layers;

  PlotRegion(
      {required this.type, required this.yAxisSettings, List<Layer>? layers})
      : layers = layers ?? [];

  void drawLayers(Canvas canvas) {
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
      layer.drawLayer(canvas: canvas);
    }
  }

  void drawAxisValue(Canvas canvas) {
    for (final layer in layers) {
      layer.drawAxisValues(canvas: canvas);
    }
  }
}
