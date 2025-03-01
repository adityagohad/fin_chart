import 'package:fin_chart/models/region/region_prop.dart';
import 'package:flutter/material.dart';

abstract class Layer with RegionProp {
  void drawLayer({required Canvas canvas});

  void drawAxisValues({required Canvas canvas}) {}

  Layer? onTapDown({required TapDownDetails details}) {
    return null;
  }

  void onScaleUpdate({required ScaleUpdateDetails details}) {}
}
