import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:flutter/material.dart';

abstract class AxisSettings {
  final TextStyle? axisTextStyle;
  final double strokeWidth;
  final Color? axisColor;

  const AxisSettings({
    this.axisTextStyle,
    this.strokeWidth = 1,
    this.axisColor,
  });

  Color getEffectiveAxisColor(ThemeData theme) {
    return axisColor ?? theme.customColors.axisColor;
  }

  TextStyle getEffectiveTextStyle(ThemeData theme) {
    if (axisTextStyle != null) return axisTextStyle!;

    final textColor =
        theme.brightness == Brightness.light ? Colors.black : Colors.white;
    return TextStyle(
      color: textColor,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'axisTextStyle': axisTextStyle != null
          ? {
              'color': colorToJson(axisTextStyle!.color),
              'fontSize': axisTextStyle!.fontSize,
              'fontWeight': fontWeightToJson(axisTextStyle!.fontWeight)
            }
          : null,
      'strokeWidth': strokeWidth,
      'axisColor': axisColor != null ? colorToJson(axisColor) : null,
    };
  }

  static TextStyle textStyleFromJson(Map<String, dynamic> json) {
    return TextStyle(
      color: colorFromJson(json['color']),
      fontSize: json['fontSize'].toDouble(),
      fontWeight: fontWeightFromJson(json['fontWeight']),
    );
  }
}
