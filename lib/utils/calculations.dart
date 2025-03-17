import 'dart:math' as math;

import 'package:fin_chart/fin_chart.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

List<double> generateNiceAxisValues(double min, double max) {
  double range = max - min;

  // Find magnitude of the range (e.g., 0.01, 0.1, 1, 10, 100, etc.)
  double magnitude =
      math.pow(10, (math.log(range) / math.ln10).floor()).toDouble();

  // Common intervals to try (as multipliers of magnitude)
  final multipliers = [
    0.01,
    0.02,
    0.025,
    0.05,
    0.1,
    0.2,
    0.25,
    0.5,
    1.0,
    2.0,
    2.5,
    5.0,
    10.0
  ];

  // Find appropriate step size
  double niceStep = magnitude *
      multipliers.firstWhere((multiplier) {
        double step = magnitude * multiplier;
        // Aim for at least 4 steps but no more than 10
        int steps = (range / step).ceil();
        return steps >= 4 && steps <= 10;
      }, orElse: () => 1.0);

  // Find nice minimum value (round down to nearest multiple of step)
  double niceMin = (min / niceStep).floor() * niceStep;

  // Find nice maximum value (round up to nearest multiple of step)
  double niceMax = (max / niceStep).ceil() * niceStep;

  // Generate the series
  List<double> series = [];
  for (double value = niceMin;
      value <= niceMax + (niceStep / 2);
      value += niceStep) {
    // Round to 2 decimal places to avoid floating point precision issues
    series.add((value * 100).round() / 100);
  }

  return series;
}

(double, double) findMinMaxWithPercentage(List<ICandle> candles) {
  if (candles.isEmpty) return (0, 1);
  double lowest = candles[0].low;
  double highest = candles[0].high;

  for (ICandle candle in candles) {
    if (candle.low < lowest) {
      lowest = candle.low;
    }
    if (candle.high > highest) {
      highest = candle.high;
    }
  }
  double range = highest - lowest;

  double lowestInt = (lowest - (range * 0.05)).floor().toDouble();
  double highestInt = (highest + (range * 0.05)).ceil().toDouble();

  return (lowestInt, highestInt);
}

Size getLargetRnderBoxSizeForList(List<String> labels, style) {
  double largestWidth = 0;
  double largetHeight = 0;
  for (String label in labels) {
    Size currentLabelSize = getTextRenderBoxSize(label, style);
    if (largestWidth < currentLabelSize.width) {
      largestWidth = currentLabelSize.width;
    }
    if (largetHeight < currentLabelSize.height) {
      largetHeight = currentLabelSize.height;
    }
  }

  return Size(largestWidth, largetHeight);
}

Size getTextRenderBoxSize(String str, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: str, style: style),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();
  return Size(
      textPainter.width + fontPadding, textPainter.height + fontPadding);
}

Color colorFromJson(String? hexString) {
  if (hexString == null || hexString.isEmpty) return Colors.black;
  final hex = hexString.startsWith('#') ? hexString.substring(1) : hexString;
  try {
    final value = int.parse(hex, radix: 16);
    if (hex.length == 6) {
      return Color(value).withAlpha(255);
    } else if (hex.length == 8) {
      return Color(value);
    } else {
      return Colors.black;
    }
  } catch (e) {
    return Colors.black;
  }
}

String colorToJson(Color color) {
  final hexAlpha = (color.a * 255).round().toRadixString(16).padLeft(2, '0');
  final hexRed = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
  final hexGreen = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
  final hexBlue = (color.b * 255).round().toRadixString(16).padLeft(2, '0');

  return '#$hexAlpha$hexRed$hexGreen$hexBlue';
}

Offset offsetFromJson(Map<String, dynamic> json) {
  return Offset(
    (json['dx'] as num).toDouble(),
    (json['dy'] as num).toDouble(),
  );
}

String generateV4() {
  final math.Random random = math.Random.secure();
  final List<int> bytes = List.generate(16, (_) => random.nextInt(256));

  bytes[6] = (bytes[6] & 0x0F) | 0x40;
  bytes[8] = (bytes[8] & 0x3F) | 0x80;

  final List<String> hexBytes = bytes.map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).toList();

  return '${hexBytes.sublist(0, 4).join()}-'
      '${hexBytes.sublist(4, 6).join()}-'
      '${hexBytes.sublist(6, 8).join()}-'
      '${hexBytes.sublist(8, 10).join()}-'
      '${hexBytes.sublist(10, 16).join()}';
}
