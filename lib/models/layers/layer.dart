import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:flutter/material.dart';

abstract class Layer with RegionProp {
  Layer.fromTool();

  Layer.fromJson();

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  void drawLayer({required Canvas canvas});

  void drawRightAxisValues({required Canvas canvas}) {}

  void drawLeftAxisValues({required Canvas canvas}) {}

  Layer? onTapDown({required TapDownDetails details}) {
    return null;
  }

  void onScaleUpdate({required ScaleUpdateDetails details}) {}

  void onScaleStart({required ScaleStartDetails details}) {}

  void onUpdateData({required List<ICandle> data}) {}

  void onAimationUpdate(
      {required Canvas canvas, required double animationValue}) {}
}
