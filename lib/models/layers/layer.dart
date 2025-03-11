import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/region/region_prop.dart';
import 'package:flutter/material.dart';

abstract class Layer with RegionProp {
  // factory Layer.fromJson(Map<String, dynamic> json) {
  //   throw UnimplementedError('Layer.fromJson() has not been implemented.');
  // }

  // factory Layer.fromTool() {
  //   throw UnimplementedError('Layer.fromTool() has not been implemented.');
  // }

  void drawLayer({required Canvas canvas});

  void drawRightAxisValues({required Canvas canvas}) {}

  void drawLeftAxisValues({required Canvas canvas}) {}

  Layer? onTapDown({required TapDownDetails details}) {
    return null;
  }

  void onScaleUpdate({required ScaleUpdateDetails details}) {}

  void onScaleStart({required ScaleStartDetails details}) {}

  void onUpdateData({required List<ICandle> data}) {}
}
