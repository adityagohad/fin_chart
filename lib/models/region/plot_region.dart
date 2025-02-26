import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class PlotRegion {
  final double topPos;
  final double bottomPos;
  final List<Layer> layers = [];

  PlotRegion({required this.topPos, required this.bottomPos});

  onTapDown(TapDownDetails details) {
    for (final layer in layers) {
      final result = layer.onTapDown(details);
      if (result != layer) {
        return result;
      }
    }
    return this;
  }
}
