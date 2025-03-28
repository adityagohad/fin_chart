import 'dart:math';

import 'package:fin_chart/models/enums/candle_state.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/indicators/indicator.dart';
import 'package:fin_chart/models/region/plot_region.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class MainPlotRegion extends PlotRegion {
  final List<ICandle> candles;
  final List<Indicator> indicators = [];

  MainPlotRegion({
    String? id,
    required this.candles,
    required super.yAxisSettings,
    super.yMinValue,
    super.yMaxValue,
  }) : super(id: id ?? generateV4()) {
    if (candles.isNotEmpty) {
      (double, double) range = findMinMaxWithPercentage(candles);

      if (yMinValue == 0 && yMaxValue == 1) {
        yMinValue = range.$1;
        yMaxValue = range.$2;
      } else {
        yMinValue = min(range.$1, yMinValue);
        yMaxValue = max(range.$2, yMaxValue);
      }

      yValues = generateNiceAxisValues(yMinValue, yMaxValue);

      yMinValue = yValues.first;
      yMaxValue = yValues.last;

      yLabelSize = getLargetRnderBoxSizeForList(
          yValues.map((v) => v.toString()).toList(),
          yAxisSettings.axisTextStyle);
    }
  }

  @override
  void updateRegionProp(
      {required double leftPos,
      required double topPos,
      required double rightPos,
      required double bottomPos,
      required double xStepWidth,
      required double xOffset,
      required double yMinValue,
      required double yMaxValue}) {
    for (Indicator indicator in indicators) {
      indicator.updateRegionProp(
          leftPos: leftPos,
          topPos: topPos,
          rightPos: rightPos,
          bottomPos: bottomPos,
          xStepWidth: xStepWidth,
          xOffset: xOffset,
          yMinValue: yMinValue,
          yMaxValue: yMaxValue);
    }
    super.updateRegionProp(
        leftPos: leftPos,
        topPos: topPos,
        rightPos: rightPos,
        bottomPos: bottomPos,
        xStepWidth: xStepWidth,
        xOffset: xOffset,
        yMinValue: yMinValue,
        yMaxValue: yMaxValue);
  }

  @override
  void updateData(List<ICandle> data) {
    candles.addAll(data.sublist(candles.isEmpty ? 0 : candles.length));
    (double, double) range = findMinMaxWithPercentage(candles);

    if (yMinValue == 0 && yMaxValue == 1) {
      yMinValue = range.$1;
      yMaxValue = range.$2;
    } else {
      yMinValue = min(range.$1, yMinValue);
      yMaxValue = max(range.$2, yMaxValue);
    }

    yValues = generateNiceAxisValues(yMinValue, yMaxValue);

    yMinValue = yValues.first;
    yMaxValue = yValues.last;

    yLabelSize = getLargetRnderBoxSizeForList(
        yValues.map((v) => v.toString()).toList(), yAxisSettings.axisTextStyle);

    for (Indicator indicator in indicators) {
      indicator.updateData(data);
    }
  }

  @override
  void drawBaseLayer(Canvas canvas) {
    for (int i = 0; i < candles.length; i++) {
      ICandle candle = candles[i];
      Color candleColor;
      if (candle.state == CandleState.selected) {
        candleColor = Colors.orange;
      } else if (candle.state == CandleState.highlighted) {
        candleColor = Colors.purple;
      } else if (candle.open < candle.close) {
        candleColor = Colors.green;
      } else {
        candleColor = Colors.red;
      }

      Paint paint = Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.fill
        ..color = candleColor;

      canvas.drawLine(Offset(toX(i.toDouble()), toY(candle.high)),
          Offset(toX(i.toDouble()), toY(candle.low)), paint);

      canvas.drawRect(
          Rect.fromLTRB(toX(i.toDouble()) - (xStepWidth) / 4, toY(candle.open),
              toX(i.toDouble()) + (xStepWidth) / 4, toY(candle.close)),
          paint);

      // if (toX(i) >= leftPos && toX(i) <= rightPos) {
      //   canvas.drawLine(Offset(toX(i), toY(candle.high)),
      //       Offset(toX(i), toY(candle.low)), paint);

      //   canvas.drawRect(
      //       Rect.fromLTRB(toX(i) - candleWidth / 2, toY(candle.open),
      //           toX(i) + candleWidth / 2, toY(candle.close)),
      //       paint);
      // }
      // if (toX(i) > rightPos) {
      //   break;
      // }
    }

    for (Indicator indicator in indicators) {
      indicator.drawIndicator(canvas: canvas);
    }
  }

  @override
  void drawYAxis(Canvas canvas) {
    double valuseDiff = yValues.last - yValues.first;
    double posDiff = bottomPos - topPos;

    for (double value in yValues) {
      double pos = bottomPos - (value - yValues.first) * posDiff / valuseDiff;

      if (!(value == yValues.first || value == yValues.last)) {
        canvas.drawLine(Offset(leftPos, pos), (Offset(rightPos, pos)), Paint());
        final TextPainter text = TextPainter(
          text: TextSpan(
            text: value.toStringAsFixed(2),
            style: yAxisSettings.axisTextStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (yAxisSettings.yAxisPos == YAxisPos.left) {
          text.paint(
              canvas,
              Offset(leftPos - (text.width + yLabelPadding / 2),
                  pos - text.height / 2));
        }
        if (yAxisSettings.yAxisPos == YAxisPos.right) {
          text.paint(canvas,
              Offset(rightPos + yLabelPadding / 2, pos - text.height / 2));
        }
      }
    }

    if (yAxisSettings.yAxisPos == YAxisPos.left) {
      canvas.drawLine(
          Offset(leftPos, topPos),
          Offset(leftPos, bottomPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
    if (yAxisSettings.yAxisPos == YAxisPos.right) {
      canvas.drawLine(
          Offset(rightPos, topPos),
          Offset(rightPos, bottomPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
  }

  @override
  Widget renderIndicatorToolTip(
      {required Indicator? selectedIndicator,
      required Function(Indicator)? onClick,
      required Function()? onSettings,
      required Function()? onDelete}) {
    return Positioned(
        left: leftPos,
        top: topPos,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...indicators.map((indicator) => indicator.indicatorToolTip(
                selectedIndicator: selectedIndicator,
                onClick: onClick,
                onSettings: onSettings,
                onDelete: onDelete))
          ],
        ));
  }
}
