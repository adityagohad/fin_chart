import 'package:fin_chart/models/enums/candle_state.dart';
import 'package:fin_chart/models/i_candle.dart';
import 'package:fin_chart/models/settings/x_axis_settings.dart';
import 'package:fin_chart/models/settings/y_axis_settings.dart';
import 'package:fin_chart/utils/calculations.dart';
import 'package:fin_chart/utils/constants.dart';
import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final double leftPos;
  final double topPos;
  final double rightPos;
  final double bottomPos;
  final double yMinValue;
  final double yMaxValue;
  final double yMinPos;
  final double xStepWidth;
  final double xOffset;
  final YAxisSettings yAxisSettings;
  final XAxisSettings xAxisSettings;
  final List<ICandle> candles;

  ChartPainter(
      {super.repaint,
      required this.leftPos,
      required this.topPos,
      required this.rightPos,
      required this.bottomPos,
      required this.yMinValue,
      required this.yMaxValue,
      required this.yMinPos,
      required this.xStepWidth,
      required this.xOffset,
      required this.yAxisSettings,
      required this.xAxisSettings,
      required this.candles});

  @override
  void paint(Canvas canvas, Size size) {
    final outerBoundries = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
        outerBoundries,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.transparent);
    canvas.clipRect(outerBoundries);

    drawYAxis(canvas);
    drawXAxis(canvas);

    final innerBoundries = Rect.fromLTRB(leftPos, topPos, rightPos, bottomPos);

    canvas.drawRect(
        innerBoundries,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.transparent);

    canvas.clipRect(innerBoundries);

    plotCandles(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  drawYAxis(Canvas canvas) {
    List<double> yValues = generateNiceAxisValues(yMinValue, yMaxValue);
    double valuseDiff = yValues.last - yValues.first;
    double posDiff = yMinPos - topPos;

    for (double value in yValues) {
      double pos = yMinPos - (value - yValues.first) * posDiff / valuseDiff;

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
          Offset(leftPos, yMinPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
    if (yAxisSettings.yAxisPos == YAxisPos.right) {
      canvas.drawLine(
          Offset(rightPos, topPos),
          Offset(rightPos, yMinPos),
          Paint()
            ..color = yAxisSettings.axisColor
            ..strokeWidth = yAxisSettings.strokeWidth);
    }
  }

  drawXAxis(Canvas canvas) {
    for (int i = 0; i < candles.length; i++) {
      if (leftPos + xOffset + xStepWidth / 2 + i * xStepWidth > leftPos &&
          leftPos + xOffset + xStepWidth / 2 + i * xStepWidth < rightPos) {
        final TextPainter text = TextPainter(
          text: TextSpan(
            text: i.toStringAsFixed(0),
            style: xAxisSettings.axisTextStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (xAxisSettings.xAxisPos == XAxisPos.bottom) {
          canvas.drawCircle(
              Offset(leftPos + xOffset + xStepWidth / 2 + i * xStepWidth,
                  bottomPos),
              1,
              Paint()..color = xAxisSettings.axisColor);

          canvas.drawLine(
              Offset(
                  leftPos + xOffset + xStepWidth / 2 + i * xStepWidth, topPos),
              (Offset(leftPos + xOffset + xStepWidth / 2 + i * xStepWidth,
                  bottomPos)),
              Paint());

          text.paint(
              canvas,
              Offset(
                  leftPos +
                      xOffset +
                      xStepWidth / 2 +
                      i * xStepWidth -
                      text.width / 2,
                  bottomPos + xLabelPadding / 2));
        }

        if (xAxisSettings.xAxisPos == XAxisPos.top) {
          canvas.drawCircle(
              Offset(
                  leftPos + xOffset + xStepWidth / 2 + i * xStepWidth, topPos),
              1,
              Paint()..color = xAxisSettings.axisColor);

          text.paint(
              canvas,
              Offset(
                  leftPos +
                      xOffset +
                      xStepWidth / 2 +
                      i * xStepWidth -
                      text.width / 2,
                  topPos - (text.height + xLabelPadding / 2)));
        }
      }
    }

    if (xAxisSettings.xAxisPos == XAxisPos.bottom) {
      canvas.drawLine(
          Offset(leftPos, bottomPos),
          Offset(rightPos, bottomPos),
          Paint()
            ..color = xAxisSettings.axisColor
            ..strokeWidth = xAxisSettings.strokeWidth);
    }

    if (xAxisSettings.xAxisPos == XAxisPos.top) {
      canvas.drawLine(
          Offset(leftPos, topPos),
          Offset(rightPos, topPos),
          Paint()
            ..color = xAxisSettings.axisColor
            ..strokeWidth = xAxisSettings.strokeWidth);
    }
  }

  plotCandles(Canvas canvas) {
    for (int i = 0; i < candles.length; i++) {
      plotCandle(canvas, i, candles[i]);
    }
  }

  plotCandle(Canvas canvas, int pos, ICandle candle) {
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

    List<double> yValues = generateNiceAxisValues(yMinValue, yMaxValue);
    double valuseDiff = yValues.last - yValues.first;
    double posDiff = yMinPos - topPos;

    canvas.drawLine(
        Offset(leftPos + xOffset + xStepWidth / 2 + pos * xStepWidth,
            yMinPos - (candle.high - yValues.first) * posDiff / valuseDiff),
        Offset(leftPos + xOffset + xStepWidth / 2 + pos * xStepWidth,
            yMinPos - (candle.low - yValues.first) * posDiff / valuseDiff),
        paint);

    canvas.drawRect(
        Rect.fromLTRB(
            leftPos +
                xOffset +
                xStepWidth / 2 +
                pos * xStepWidth -
                candleWidth / 2,
            yMinPos - (candle.open - yValues.first) * posDiff / valuseDiff,
            leftPos +
                xOffset +
                xStepWidth / 2 +
                pos * xStepWidth +
                candleWidth / 2,
            yMinPos - (candle.close - yValues.first) * posDiff / valuseDiff),
        paint);
  }
}
