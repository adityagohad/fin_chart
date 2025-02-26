import 'package:fin_chart/models/layers/layer.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends Layer {
  double value;

  HorizontalLine({required this.value});
  @override
  void draw(Canvas canvas) {
    // TODO: implement draw
  }

  @override
  Layer onTapDown(TapDownDetails details) {
    throw UnimplementedError();
  }

  @override
  void drawAxisIndicators(Canvas canvas) {
    // TODO: implement drawAxisIndicators
  }
}
