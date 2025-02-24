import 'package:flutter/material.dart';

abstract class AxisSettings {
  final TextStyle axisTextStyle;
  final double strokeWidth;
  final Color axisColor;

  const AxisSettings(
      {this.axisTextStyle = const TextStyle(
          color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
      this.strokeWidth = 1,
      this.axisColor = Colors.black});
}
